class BST:
    def __init__(self, left=None, right=None,
                 parent=None, key=None, data=None):
        self.left = left
        self.right = right
        self.parent = parent
        self.key = key
        self.data = data

    def print(self, level=0, dir=''):
        print(level*" " + dir + str((self.key, self.data)))
        if self.left is not None:
            self.left.print(level+1, dir='l ')
        if self.right is not None:
            self.right.print(level+1, dir='r ')

    def search(self, key):
        while self is not None:
            if self.key == key:
                return self
            elif self.key < key:
                self = self.right
            else:
                self = self.left
        return None

    def min(self):
        while self.left is not None:
            self = self.left
        return self

    def max(self):
        while self.right is not None:
            self = self.right
        return self

    def succ(self, key=None):
        if key is None:
            key = self.key
        if self.right is None:
            while self.parent is not None and self.parent.key < key:
                self = self.parent
            return self.parent
        return self.right.min()

    def pred(self, key=None):
        if key is None:
            key = self.key
        if self.left is None:
            while self.parent is not None and self.parent.key > key:
                self = self.parent
            return self.parent
        return self.left.max()

    def insert(self, key, data=None):
        # Safety check
        # if self.key is None:
        #     self.key = key
        #     self.data = data
        #     return

        parent = self
        while self is not None:
            if self.key == key:  # Safety check
                raise KeyError("Key already present")

            parent = self
            if self.key > key:
                self = self.left
            else:
                self = self.right

        new = BST(parent=parent, key=key, data=data)
        if parent.key > key:
            parent.left = new
        else:
            parent.right = new

    def remove(self, key=None):
        if key is None:
            key = self.key

        while True:
            if self is None:
                raise KeyError("Key not present in tree")

            if self.key > key:
                self = self.left
            elif self.key < key:
                self = self.right

            else:
                if self.left is None and self.right is None:
                    if self.parent.left is self:
                        self.parent.left = None
                    else:
                        self.parent.right = None

                elif self.left is None and self.right is not None:
                    if self.parent.left is self:
                        self.parent.left = self.right
                    else:
                        self.parent.right = self.right
                    self.right.parent = self.parent

                elif self.right is None and self.left is not None:
                    if self.parent.left is self:
                        self.parent.left = self.left
                    else:
                        self.parent.right = self.left
                    self.left.parent = self.parent

                else:
                    succ = self.right.min()
                    self.key = succ.key
                    self.data = succ.data
                    succ.remove()

                return
