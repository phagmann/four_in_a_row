class Ai
# TODO: redo AI from js
    require 'pp'
    # evaluation fuction
    # Marshal.load(Marshal.dump(2d_array))
    def self.if_array_win(data1)
        (0..(data1[0].length - 1)).each do |col|
            (0..(data1.length - 1)).each do |row|
                target = data1[col][row]
                next if target == 0
                (-1..1).each do |y|
                    (-1..1).each do |x|
                        curX= row + x
                        curY= col + y
                        if (curX  >= 0 && curX < data1.length  && curY  >= 0 && curY < data1[0].length)
                            if (data1[curY][curX] == target  && !(x == 0 && y == 0) )
                                curX = curX + (curX - row)
                                curY = curY + (curY - col)
                                if (curX  >= 0 && curX < data1.length  && curY  >= 0 && curY < data1.length)
                                    if (data1[curY][curX] == target && data1[curY][curX]!= 0 && !(x == 0 && y == 0) )
                                        curX = curX + (curX - row - x)
                                        curY = curY + (curY - col- y)
                                        if (curX  >= 0 && curX < data1.length  && curY  >= 0 && curY < data1[0].length)
                                            return target if (data1[curY][curX] == target)
                                        end
                                    end

                                end
                            end

                        end

                    end
                end

            end

        end
        return 90
    end

    def self.evaluation(data1, spot)
        player_sign = 2*data1[spot[0]][spot[1]] - 3
        pos = 0
        check = Ai.if_array_win(Marshal.load(Marshal.dump(data1)))
        return -1000000 if check == 1
        return 1000000 if check == 2
        (-1..1).each do |y|
            (-1..1).each do |x|
                if (spot[1] + x  >= 0 && spot[1] + x < data1.length  && spot[0] + y >= 0 && spot[0] + y< data1.length && !(x==0 && y==0))
                    pos += 1 if(data1[spot[0] + y][spot[1] + x] > 0)
                end



            end
        end
        return player_sign*pos
    end




    # drop piece down

    def self.drop_piece(data1, spot, depth)
        # HELP: data passed to if_array_win is off!
        player = depth % 2 + 1
        data1[spot[0]][spot[1]] = player
        
        return [data1,Ai.evaluation(data1,spot)]
    end




    # find avalible moves. returns cordinates and not "g#" like in js

    def self.find_choices(data1)
        store =[]
        (0..(data1[0].length - 1)).each do |change_col|
            (0..(data1[0].length - 1)).reverse_each do |i|
                if (data1[i][change_col] == 0)
                    store << [i,change_col]
                    break
                end
            end
        end
        return store
    end

    class Node
    attr_accessor :value, :next_node, :previous, :alpha, :beta, :board, :uncontested, :total, :gdex
        def initialize( next_node = nil, previous= [], alpha = - 1.0/0 , beta = 1.0/0, board = nil, uncontested = [], total=0, gdex=0  )
            self.next_node = next_node
            self.previous = previous
            self.alpha = alpha
            self.beta = beta
            self.board = board
            self.uncontested = uncontested
            self.total = total
            self.gdex = gdex
        end

    end
    class Tree
        attr_accessor :currentNode, :depth, :leading
        def initialize(currentNode=nil, depth=0, leading = - 1.0/0)
          self.currentNode = currentNode
          self.depth = depth
          self.leading = leading
        end

        def PreviousNodeAt(index)
            return self.currentNode.previous[index]
        end

        def Next 
            self.currentNode = self.currentNode.next_node
        end

        def Value
            return self.currentNode.value
        end

        def newadd(value, data)
            node = Node.new
            node.value = value
            if self.currentNode == nil
                self.currentNode = node
                self.depth += 1
                self.currentNode.board = Marshal.load(Marshal.dump(data))
                self.currentNode.uncontested = Ai.find_choices(Marshal.load(Marshal.dump(self.currentNode.board)))
                self.currentNode
                return
            end

            node.next_node = self.currentNode
            self.currentNode.previous.push(node)
            
            self.currentNode = node
            self.currentNode.alpha = self.currentNode.next_node.alpha
            self.currentNode.beta = self.currentNode.next_node.beta

            b = Ai.drop_piece(Marshal.load(Marshal.dump(self.currentNode.next_node.board)), self.currentNode.next_node.uncontested[self.currentNode.next_node.gdex], self.depth)


         
            self.currentNode.board = Marshal.load(Marshal.dump(b[0]))
            if self.currentNode.next_node.total < 10000 && self.currentNode.next_node.total > -10000 then self.currentNode.total = self.currentNode.next_node.total + b[1] else self.currentNode.total = self.currentNode.next_node.total  end 
            self.currentNode.uncontested = Ai.find_choices(Marshal.load(Marshal.dump(self.currentNode.board)))
            self.currentNode.next_node.gdex += 1
            self.depth += 1
            return



        end

        def add(value)
            node = Node.new
            node.value = value
            node.next_node = self.currentNode
            self.currentNode.previous.push(node)
            b = Ai.drop_piece(Marshal.load(Marshal.dump(self.currentNode.board)), self.currentNode.uncontested[self.currentNode.gdex], self.depth)

            if self.currentNode.total < 10000 && self.currentNode.total > -10000 then self.PreviousNodeAt(self.currentNode.gdex).value = self.currentNode.total + b[1] else self.PreviousNodeAt(self.currentNode.gdex).value = self.currentNode.total end
            self.currentNode.gdex += 1
            pp b[0]
            pp self.PreviousNodeAt(self.currentNode.gdex - 1).value
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


    ################################################################################

    




    def self.AplhaBetaPruning(data, depth)
        #get right cordinates to iterate through. gdex  and find_choices
        q = Tree.new
        q.newadd(nil,Marshal.load(Marshal.dump(data)))
        childern = q.currentNode.uncontested.length
        countdown = childern
        leader = q.currentNode.uncontested[0]
        while countdown > 0
            
            if q.currentNode.uncontested != nil && q.getDepth() < depth - 1 && q.currentNode.gdex < q.currentNode.uncontested.length 
                if q.ifPrune
                    q.currentNode.uncontested = []
                    next
                end

                q.newadd(nil,nil)
                next

            elsif q.getDepth >= depth - 1
                (0..q.currentNode.uncontested.length-1).each do |z|
                    q.add(nil)
                    if q.ifPrune
                        q.getAlphaBeta(q.getDepth,z)
                        break
                    end
                    q.getAlphaBeta(q.getDepth,z)
                end
                
                q.moveAlphaBetaUp (q.getDepth)
                q.Next

            else
                
                q.moveAlphaBetaUp (q.getDepth)
                q.Next

            end


            if q.currentNode.next_node == nil
                pp "try time"
                pp q.currentNode.uncontested[childern - countdown]
                pp q.Value()
                if (q.leading < q.Value() )
                    leader = q.currentNode.uncontested[childern - countdown]
                    q.leading = q.Value()
                end
                countdown -= 1
                if countdown <= 0
                    puts "win"
                    puts leader
                    return leader
                end
                q.newadd(nil,nil)
            end


        end

    return "fail loser"




    end




    # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
    # TODO: get this working for my code!




    # find if someone won





    # AlphaBetaPruning runs 

    def self.ComputersTurn(data)
        return Ai.AplhaBetaPruning(Marshal.load(Marshal.dump(data)),7)
    end



end

