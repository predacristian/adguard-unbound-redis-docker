#!/bin/sh

set -e

echo "Running Redis server test..."

# Function to check Redis process
check_redis_process() {
    echo "Checking Redis process..."
    ps aux | grep redis-server || echo "Redis process not found"
}

# Function to check Redis port
check_redis_port() {
    echo "Checking Redis port status..."
    netstat -tuln | grep -E ':6379'
}

# Function to test Redis connection with retries
test_redis_connection() {
    local redis_connected=false
    local i=1
    while [ $i -le 3 ]; do
        if redis-cli -p 6379 ping | grep -q 'PONG'; then
            redis_connected=true
            echo "Redis connection successful"
            break
        fi
        echo "Redis connection attempt $i failed, retrying..."
        i=$((i + 1))
        sleep 2
    done

    if [ "$redis_connected" != "true" ]; then
        echo "Redis server test failed: Cannot connect to Redis"
        exit 1
    fi
}

# Function to test basic Redis operations
test_redis_operations() {
    echo "Testing Redis operations..."

    # Test SET operation
    if ! redis-cli -p 6379 set test_key "Hello, Redis!" > /dev/null; then
        echo "Redis SET operation failed"
        exit 1
    fi

    # Test GET operation
    value=$(redis-cli -p 6379 get test_key)
    if [ "$value" != "Hello, Redis!" ]; then
        echo "Redis GET operation failed"
        exit 1
    fi

    # Test EXISTS operation
    if ! redis-cli -p 6379 exists test_key > /dev/null; then
        echo "Redis EXISTS operation failed"
        exit 1
    fi

    # Test DEL operation
    if ! redis-cli -p 6379 del test_key > /dev/null; then
        echo "Redis DEL operation failed"
        exit 1
    fi
}

# Function to test Redis performance
test_redis_performance() {
    echo "Testing Redis performance..."
    redis-cli -p 6379 ping | grep -q 'PONG' && echo "Response time test passed"
}

# Show diagnostic information
check_redis_process
check_redis_port

# Run tests
test_redis_connection
test_redis_operations
test_redis_performance

echo "Redis server test completed successfully"
