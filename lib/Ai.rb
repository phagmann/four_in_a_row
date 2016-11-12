module Ai
# TODO: redo AI from js
require 'pp'
class Node
attr_accessor :value, :next_node, :previous, :alpha, :beta, :pruned
    def initialize( next_node = nil, previous= [], alpha = - 1.0/0 , beta = 1.0/0, pruned = 0  )
        self.next_node = next_node
        self.previous = previous
        self.alpha = alpha
        self.beta = beta
        self.pruned = pruned
    end

end
class Tree
    attr_accessor :currentNode, :size
    def initialize(currentNode=nil, size=0)
      self.currentNode = currentNode
      self.size = size
    end

    def PreviousNodeAt(index)
        return self.currentNode.previous[index]
    end

    def PreviousSetLength
        return self.currentNode.previous.length
    end

    def PreviousValues
        set = []
        (0..(this.currentNode.previous.length -1)).each do |i|
            set << self.PreviousNodeAt(i).value
        end
        return set
    end

    def Next 
        self.currentNode = self.currentNode.next_node
    end

    def Value
        return self.currentNode.value
    end

    def newadd(value)
        node = Node.new
        node.value = value
        if self.currentNode == nil
            pp "shots!"
            self.currentNode = node
            self.size += 1
            return
        end

        node.next_node = self.currentNode
        self.currentNode.previous.push(node)
        self.size += 1
        self.currentNode = node
        self.currentNode.alpha = self.currentNode.next_node.alpha
        self.currentNode.beta = self.currentNode.next_node.beta
        return



    end

    def add(value)
        node = Node.new
        node.value = value
        node.next_node = self.currentNode
        self.currentNode.previous.push(node)
        self.size += 1
        return
    end

    def getDepth
        start = self.currentNode
        depth = 1
        # wtf is wrong with next_node and previous they are not set as nil??
        while start.next_node != nil
            start = start.next_node
            depth += 1
        end
        return depth
    end


    def ifPrune
        if self.currentNode.alpha >= self.currentNode.beta then return true else return false end
    end

    def getAlphaBeta(depth, index)
        if depth % 2 == 0
            if self.PreviousNodeAt(index).value < self.currentNode.beta
                self.currentNode.beta = self.PreviousNodeAt(index).value
                self.currentNode.value = self.currentNode.beta
            end

        else
            if self.PreviousNodeAt(index).value > self.currentNode.alpha
                self.currentNode.alpha = self.PreviousNodeAt(index).value
                self.currentNode.value = self.currentNode.alpha
            end

        end

    end

    def moveAlphaBetaUp(depth)
        if depth % 2 == 0
            if self.currentNode.beta > self.currentNode.next_node.alpha
                self.currentNode.next_node.alpha = self.currentNode.beta
                self.currentNode.next_node.value = self.currentNode.next_node.alpha
            end

        else
            if self.currentNode.alpha < self.currentNode.next_node.beta
                self.currentNode.next_node.beta = self.currentNode.alpha
                self.currentNode.next_node.value = self.currentNode.next_node.beta
            end

        end

    end





end



end