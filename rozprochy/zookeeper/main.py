import subprocess
from kazoo.client import KazooClient  # type: ignore
from sys import argv
from threading import Lock
# from pathlib import Path

# https://stackoverflow.com/a/76691030
ELBOW = "└──"
PIPE = "│  "
TEE = "├──"
BLANK = "   "

ZNODE_PATH = "/node" if len(argv) < 2 else argv[1]
NOTIFY_TIME = 2500


class ZooKeeperApp:
    def __init__(self):
        self.lock = Lock()
        self.children = []
        self.id = 0
        self.tree_view = ""
        self.all_children = 0

        self.zk = KazooClient(hosts="127.0.0.1:2181")
        self.zk.start()
        print("zookeeper running")
        if self.zk.exists(ZNODE_PATH, watch=self.on_node_changed):
            self.zk.ChildrenWatch(ZNODE_PATH)(
                lambda children: self.on_children_changed(
                    ZNODE_PATH, children
                )
            )
        self.lock.acquire(True)
        self.lock.acquire(True)

    def message(self, summary, body="", time=NOTIFY_TIME):
        args = [
            "notify-send",
            "-r",
            str(self.id),
            "-t",
            str(time),
            "-p",
            summary,
        ]
        if len(body) > 0:
            args.append(body)
        process = subprocess.Popen(args, stdout=subprocess.PIPE)
        stdout, _ = process.communicate()
        self.id = int(stdout.strip())

    def exit(self):
        self.message("", "", 1)
        self.lock.release()

    def on_node_changed(self, event):
        if event.type == "DELETED":
            if self.zk.exists(ZNODE_PATH, watch=self.on_node_changed) is None:
                self.exit()
        elif event.type == "CREATED":
            self.zk.exists(ZNODE_PATH, watch=self.on_node_changed)
            self.zk.ChildrenWatch(ZNODE_PATH)(
                lambda children: self.on_children_changed(
                    ZNODE_PATH, children
                )
            )

    def on_children_changed(self, path, children):
        for child in children:
            child_path = f"/{path}/{child}"
            self.zk.ChildrenWatch(child_path)(
                lambda children: self.on_children_changed(
                    child_path, children
                )
            )

        self.all_children = 0
        self.tree_view = ""
        self.update_tree_view(ZNODE_PATH, "")
        print("Updated tree:")
        print(self.tree_view)
        self.update_children()

    def update_tree_view(self, node, parent, last=True, header=""):
        children = self.zk.get_children(node)
        self.all_children += len(children)
        self.tree_view += header + (ELBOW if last else TEE) + node + "\n"

        for i in range(len(children)):
            child_path = f"{node}/{children[i]}"
            self.update_tree_view(
                child_path,
                node,
                i == len(children) - 1,
                header + (BLANK if last else PIPE),
            )

    def update_children(self):
        try:
            self.children = self.zk.get_children(ZNODE_PATH)
        except Exception:
            self.children = []
            return

        self.message(
            "Children changed",
            f"""
Direct children: {str(len(self.children))}
All children: {str(self.all_children)}
            """,
        )


if __name__ == "__main__":
    app = ZooKeeperApp()
