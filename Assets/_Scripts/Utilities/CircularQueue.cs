using System;
using System.Collections;
using System.Collections.Generic;

namespace Utilities
{
    /// <summary>
    /// A generic circular queue implementation with fixed size.
    /// Elements are stored in a circular buffer and automatically overwrite the oldest elements when capacity is exceeded.
    /// </summary>
    /// <typeparam name="T">The type of elements stored in the queue</typeparam>
    public class CircularQueue<T> : IEnumerable<T>
    {
        private readonly T[] _buffer;
        private readonly int _capacity;
        private int _head;
        private int _tail;
        private int _count;

        /// <summary>
        /// Gets the maximum capacity of the circular queue.
        /// </summary>
        public int Capacity => _capacity;

        /// <summary>
        /// Gets the current number of elements in the queue.
        /// </summary>
        public int Count => _count;

        /// <summary>
        /// Gets a value indicating whether the queue is empty.
        /// </summary>
        public bool IsEmpty => _count == 0;

        /// <summary>
        /// Gets a value indicating whether the queue is full.
        /// </summary>
        public bool IsFull => _count == _capacity;

        /// <summary>
        /// Initializes a new instance of the CircularQueue class with the specified capacity.
        /// </summary>
        /// <param name="capacity">The maximum number of elements the queue can hold</param>
        /// <exception cref="ArgumentException">Thrown when capacity is less than or equal to zero</exception>
        public CircularQueue(int capacity)
        {
            if (capacity <= 0)
                throw new ArgumentException("Capacity must be greater than zero.", nameof(capacity));

            _capacity = capacity;
            _buffer = new T[capacity];
            _head = 0;
            _tail = 0;
            _count = 0;
        }

        /// <summary>
        /// Adds an element to the rear of the queue.
        /// If the queue is full, the oldest element is overwritten.
        /// </summary>
        /// <param name="item">The element to add to the queue</param>
        public void Enqueue(T item)
        {
            _buffer[_tail] = item;
            
            if (IsFull)
            {
                // Queue is full, move head forward (overwrite oldest element)
                _head = (_head + 1) % _capacity;
            }
            else
            {
                _count++;
            }
            
            _tail = (_tail + 1) % _capacity;
        }

        /// <summary>
        /// Removes and returns the element at the front of the queue.
        /// </summary>
        /// <returns>The element that was removed from the front of the queue</returns>
        /// <exception cref="InvalidOperationException">Thrown when the queue is empty</exception>
        public T Dequeue()
        {
            if (IsEmpty)
                throw new InvalidOperationException("Cannot dequeue from an empty queue.");

            T item = _buffer[_head];
            _buffer[_head] = default(T); // Clear the reference for GC
            _head = (_head + 1) % _capacity;
            _count--;

            return item;
        }

        /// <summary>
        /// Returns the element at the front of the queue without removing it.
        /// </summary>
        /// <returns>The element at the front of the queue</returns>
        /// <exception cref="InvalidOperationException">Thrown when the queue is empty</exception>
        public T Peek()
        {
            if (IsEmpty)
                throw new InvalidOperationException("Cannot peek at an empty queue.");

            return _buffer[_head];
        }

        /// <summary>
        /// Removes all elements from the queue.
        /// </summary>
        public void Clear()
        {
            Array.Clear(_buffer, 0, _capacity);
            _head = 0;
            _tail = 0;
            _count = 0;
        }

        /// <summary>
        /// Determines whether the queue contains a specific element.
        /// </summary>
        /// <param name="item">The element to locate in the queue</param>
        /// <returns>true if the element is found; otherwise, false</returns>
        public bool Contains(T item)
        {
            var comparer = EqualityComparer<T>.Default;
            
            for (int i = 0; i < _count; i++)
            {
                int index = (_head + i) % _capacity;
                if (comparer.Equals(_buffer[index], item))
                    return true;
            }
            
            return false;
        }

        /// <summary>
        /// Copies the queue elements to an array, starting at the specified array index.
        /// </summary>
        /// <param name="array">The destination array</param>
        /// <param name="arrayIndex">The zero-based index in array at which copying begins</param>
        /// <exception cref="ArgumentNullException">Thrown when array is null</exception>
        /// <exception cref="ArgumentOutOfRangeException">Thrown when arrayIndex is invalid</exception>
        /// <exception cref="ArgumentException">Thrown when the destination array is too small</exception>
        public void CopyTo(T[] array, int arrayIndex)
        {
            if (array == null)
                throw new ArgumentNullException(nameof(array));
            
            if (arrayIndex < 0 || arrayIndex >= array.Length)
                throw new ArgumentOutOfRangeException(nameof(arrayIndex));
            
            if (array.Length - arrayIndex < _count)
                throw new ArgumentException("Destination array is too small.");

            for (int i = 0; i < _count; i++)
            {
                int bufferIndex = (_head + i) % _capacity;
                array[arrayIndex + i] = _buffer[bufferIndex];
            }
        }

        /// <summary>
        /// Converts the queue to an array.
        /// </summary>
        /// <returns>An array containing all elements in the queue in order</returns>
        public T[] ToArray()
        {
            T[] result = new T[_count];
            CopyTo(result, 0);
            return result;
        }

        /// <summary>
        /// Returns an enumerator that iterates through the circular queue.
        /// </summary>
        /// <returns>An enumerator for the queue</returns>
        public IEnumerator<T> GetEnumerator()
        {
            for (int i = 0; i < _count; i++)
            {
                int index = (_head + i) % _capacity;
                yield return _buffer[index];
            }
        }

        /// <summary>
        /// Returns an enumerator that iterates through the circular queue.
        /// </summary>
        /// <returns>An enumerator for the queue</returns>
        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }

        /// <summary>
        /// Returns a string representation of the queue.
        /// </summary>
        /// <returns>A string representation of the queue</returns>
        public override string ToString()
        {
            if (IsEmpty)
                return "CircularQueue: []";

            var elements = new string[_count];
            for (int i = 0; i < _count; i++)
            {
                int index = (_head + i) % _capacity;
                elements[i] = _buffer[index]?.ToString() ?? "null";
            }

            return $"CircularQueue: [{string.Join(", ", elements)}]";
        }
    }
}
