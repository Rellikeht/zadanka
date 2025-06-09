import subprocess
from kazoo.client import KazooClient  # type: ignore
# import time
# from pathlib import Path


# import tkinter as tk
# from tkinter import ttk
from sys import argv
from threading import Lock

ZNODE_PATH = "/node" if len(argv) < 2 else argv[1]
NOTIFY_TIME = 2000


class ZooKeeperApp:
    def __init__(self):
        self.children = []
        self.id = 0
        self.lock = Lock()
        self.treeview = ""
        self.all_children = 0

        # print("zookeeper started")
        self.zk = KazooClient(hosts="127.0.0.1:2181")
        self.zk.start()
        print("zookeeper running")
        if self.zk.exists(ZNODE_PATH, watch=self.on_node_changed):
            # self.root.deiconify()
            self.zk.ChildrenWatch(ZNODE_PATH)(
                lambda children: self.on_children_changed(
                    ZNODE_PATH, children
                )
            )
        self.lock.acquire(True)
        self.lock.acquire(True)
        # self.create_gui()

    def message(self, summary, body=""):
        args = [
            "notify-send",
            "-r",
            str(self.id),
            "-t",
            str(NOTIFY_TIME),
            "-p",
            summary,
        ]
        if len(body) > 0:
            args.append(body)
        process = subprocess.Popen(args, stdout=subprocess.PIPE)
        stdout, _ = process.communicate()
        self.id = int(stdout.strip())
        print(summary)
        if len(body) > 0:
            print(body)

    def exit(self):
        # TODO destroy notification
        self.lock.release()

    def on_node_changed(self, event):
        # self.message("Event: " + str(event))
        if event.type == "DELETED":
            if self.zk.exists(ZNODE_PATH, watch=self.on_node_changed) is None:
                self.exit()
            # self.root.withdraw()
        elif event.type == "CREATED":
            self.zk.exists(ZNODE_PATH, watch=self.on_node_changed)
            self.zk.ChildrenWatch(ZNODE_PATH)(
                lambda children: self.on_children_changed(
                    ZNODE_PATH, children
                )
            )
            # self.root.deiconify()

    def on_children_changed(self, path, children):
        for child in children:
            child_path = f"/{path}/{child}"
            self.zk.ChildrenWatch(child_path)(
                lambda children: self.on_children_changed(
                    child_path, children
                )
            )
        # self.populate_treeview()
        # self.update_treeview()

        self.all_children = 0
        self.update_tree_view(ZNODE_PATH, "")
        self.update_children()

    # def create_gui(self):
    #     self.root = tk.Tk()
    #     self.root.withdraw()
    #     self.root.title("ZooKeeper App")
    #     self.child_count_label = tk.Label(
    #         self.root, text="Current number of children: 0"
    #     )
    #     self.child_count_label.pack()
    #     self.children_listbox = tk.Listbox(self.root)
    #     self.children_listbox.pack()

    #     self.treeview = ttk.Treeview(self.root)
    #     self.treeview.heading("#0", text="Node Structure", anchor="w")
    #     self.treeview.pack()

    #     self.root.after(1000, self.start_zookeeper)
    #     self.root.mainloop()

    # def destroy_gui(self):
    #     self.root.destroy()

    # # def print_tree(self, node, last=True, header=''):
    # def print_tree(p: Path, last=True, header=''):
    #     elbow = "└──"
    #     pipe = "│  "
    #     tee = "├──"
    #     blank = "   "
    #     print(header + (elbow if last else tee) + p.name)
    #     if p.is_dir():
    #         children = list(p.iterdir())
    #         for i, c in enumerate(children):
    #             print_tree(c, header=header + (blank if last else pipe), last=i == len(children) - 1)
    # print_tree(Path("./MNE-001-2014-bids-cache"))

    def update_tree_view(self, node, parent):
        children = self.zk.get_children(node)
        self.all_children += len(children)
        for child in children:
            child_path = f"{node}/{child}"
            self.update_tree_view(child_path, node)

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

        # self.child_count_label.config(
        #     text="Current number of children: " + str(len(self.children))
        # )
        # self.children_listbox.delete(0, tk.END)
        # for child in self.children:
        #     self.children_listbox.insert(tk.END, child)

    # def update_treeview(self):
    #     print("Updating treeview")
    #     self.treeview.delete(*self.treeview.get_children())
    #     self.populate_treeview(ZNODE_PATH, "")


if __name__ == "__main__":
    app = ZooKeeperApp()
