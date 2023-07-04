# originally developed by kfischer_okarin here:
# https://github.com/kfischer-okarin/dragon_skeleton/blob/main/lib/dragon_skeleton/pathfinding/priority_queue.rb

class Heap
  def initialize
    @data = [nil]
  end

  def insert(element, priority)
    @data << { element: element, priority: priority }
    heapify_up(@data.size - 1)
  end

  def pop
    result = @data[1]&.[](:element)
    last_element = @data.pop
    unless empty?
      @data[1] = last_element
      heapify_down(1)
    end
    result
  end

  def empty?
    @data.size == 1
  end

  def clear
    @data = [nil]
  end

  private

  def heapify_up(index)
    return if index == 1

    # parent_index = index.idiv 2
    parent_index = (index / 2).to_i
    return if @data[index][:priority] >= @data[parent_index][:priority]

    swap(index, parent_index)
    heapify_up(parent_index)
  end

  def heapify_down(index)
    smallest_child_index = smallest_child_index(index)

    return unless smallest_child_index

    return if @data[index][:priority] < @data[smallest_child_index][:priority]

    swap(index, smallest_child_index)
    heapify_down(smallest_child_index)
  end

  def swap(index1, index2)
    @data[index1], @data[index2] = [@data[index2], @data[index1]]
  end

  def smallest_child_index(index)
    left_index = index * 2
    left_value = @data[left_index]
    right_index = (index * 2) + 1
    right_value = @data[right_index]

    return nil unless left_value || right_value
    return left_index unless right_value
    return right_index unless left_value

    left_value[:priority] < right_value[:priority] ? left_index : right_index
  end
end
