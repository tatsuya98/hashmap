class Hashmap
  attr_accessor :bucket

  def initialize
    @buckets = Array.new(2.pow(4))
  end

  def hash(string)
    hash_code = 0
    prime_number = 31
    string.each_char { |char| hash_code = prime_number * hash_code + char.ord }
    hash_code
  end

  def set(key, value)
    index = hash(key) % @buckets.length
    raise IndexError if index.negative? || index >= @buckets.length

    increase_capacity(@buckets) if bucket_full?(@buckets)
    if @buckets[index].nil?
      @buckets[index] = LinkList.new(Node.new(key, value))
    elsif @buckets[index].head.key == key
      @buckets[index].head.value = value
    else
      @buckets[index].append_node(key, value)
    end
  end

  def bucket_full?(array)
    array.reject(&:nil?).length / array.length > 0.75
  end

  def increase_capacity(array)
    capacity = 2.pow(Integer.sqrt(array.length) + 1)
    @buckets = Array.new(capacity)
    @buckets.push(*array)
  end

  def get(key)
    index = hash(key) % @buckets.length
    @buckets[index].head.value
  end

  def key?(key)
    index = hash(key) % @buckets.length
    @buckets[index].head.key == key
  end

  def remove(key)
    index = hash(key) % @buckets.length
    if @buckets[index].nil?
      nil
    else
      removed_entry = @buckets[index].head
      @buckets[index] = nil
      removed_entry
    end
  end

  def length
    keys = 0
    @buckets.each do |element|
      next if element.nil?

      keys += 1
    end
    keys
  end

  def clear
    index = 0
    while index < @buckets.length
      if @buckets[index].nil?
        index += 1
        next
      else
        @buckets[index] = nil
        index += 1
      end
    end
  end

  def keys
    keys_array = []
    @buckets.each do |element|
      next if element.nil?

      keys_array << element.head.key
    end
    keys_array
  end

  def values
    values_array = []
    @buckets.each do |element|
      next if element.nil?

      values_array << element.head.value
    end
    values_array
  end

  def entries
    entries_array = []
    @buckets.each do |element|
      next if element.nil?

      entries_array << [element.head.key, element.head.value]
    end
    entries_array
  end
end

class Node
  attr_accessor :value, :key, :next_node

  def initialize(key, value, next_node = nil)
    @key = key
    @value = value
    @next_node = next_node
  end
end

class LinkList
  attr_accessor :head

  def initialize(head = nil)
    @head = head
  end

  def append_node(key, value)
    if @head.nil?
      @head = Node.new(value, key, nil)
    else
      last_node = @head
      last_node = last_node.next_node until last_node.next_node.nil?
      last_node.next_node = Node.new(value, nil)
    end
  end

  def prepend_node(key, value)
    tmp_node = @head
    @head = Node.new(key, value, tmp_node)
  end

  def length
    linked_list_length = 0
    last_node = @head
    until last_node.nil?
      linked_list_length += 1
      last_node = last_node.next_node
    end
    puts linked_list_length
  end

  def first
    @head
  end

  def tail
    tail = @head
    tail = tail.next_node until tail.next_node.nil?
    tail
  end

  def index_at(index)
    i = 0
    node = @head
    indexed_node = ''
    while i <= index
      indexed_node = node
      node = node.next_node
      i += 1
    end
    indexed_node
  end

  def pop
    node = @head
    second = nil
    until node.next_node.nil?
      second = node
      node = node.next_node
    end
    second.next_node = nil
  end

  def contains?(value)
    check = false
    node = @head
    until node.next_node.nil?
      check = node.value == value
      node = node.next_node
    end
    check
  end

  def find(value)
    index = 0
    node = @head
    until node.next_node.nil?
      break if node.value == value

      index += 1
      node = node.next_node
    end
    node.value != value ? nil : index
  end

  def to_s
    node = @head
    until node.next_node.nil?
      print "(#{node.value}) -> "
      node = node.next_node
    end
    print 'nil'
  end

  def insert_at(index, value, key)
    node = @head
    previous_node = nil
    i = 0
    while i < index
      previous_node = node
      node = node.next_node
      i += 1
    end
    previous_node.next_node = Node.new(key, value, node)
  end

  def remove_at(index)
    node = @head
    previous_node = nil
    i = 0
    while i <= index
      previous_node = node if i < index
      node = node.next_node
      i += 1
    end
    previous_node.next_node = node
  end
end
