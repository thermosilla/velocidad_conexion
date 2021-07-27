class Data:
    def __init__(self):
        self.list = []
        self.formatedList = []
        self._index = 0

    def append(self, data):
        self.list.append(data)
        return self

    def clean(self,word_list):
        for word in word_list:
            self.list = [x for x in self.list if word not in x]
        return self

    def format(self):
        self.formatedList = []
        for line in self.list:
            lista = line.replace(",",".").replace("(","").replace(")","").split()
            del lista[4:8]
            lista = [lista[0] + " " + lista[1], lista[2], lista[3]]
            self.formatedList.append(lista)
        return self


