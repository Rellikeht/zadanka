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

    def pred(self, key):
        NotImplemented
        if self.left is None:
            while self.parent is not None and self.parent.left.key < self.key:
                self = self.parent
            if self.parent is None:
                return None
            elif self.parent.left.key >= self.key:
                return self.parent
        return self.left.max()

    def succ(self, key):
        NotImplemented

        return self.right.min()

    def insert(self, key, data):
        # Safety check
        # if self.key is None:
        #     self.key = key
        #     self.data = data
        #     return

        parent = self
        while self is not None:
            parent = self

            # Safety check
            if self.key == key:
                raise KeyError("Key already present")

            if self.key < key:
                self = self.left
            else:
                self = self.right

        new = BST(parent=parent, key=key, data=data)
        if key < parent.key:
            parent.left = new
        else:
            parent.right = new

    def remove(self, key):
        NotImplemented
