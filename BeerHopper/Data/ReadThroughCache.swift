import Foundation

struct CacheEntry<Value> {
    let value: Value
    let storedAt: Date
}

protocol ClockProviding {
    var now: Date { get }
}

struct SystemClock: ClockProviding {
    var now: Date {
        return Date()
    }
}

actor ReadThroughCache<Key: Hashable, Value> {
    private let clock: ClockProviding
    private let timeToLive: TimeInterval
    private var entries: [Key: CacheEntry<Value>]

    init(
        timeToLive: TimeInterval,
        clock: ClockProviding = SystemClock(),
        entries: [Key: CacheEntry<Value>] = [:]
    ) {
        self.timeToLive = timeToLive
        self.clock = clock
        self.entries = entries
    }

    func value(for key: Key) -> Value? {
        guard let entry = self.entries[key] else {
            return nil
        }

        guard self.clock.now.timeIntervalSince(entry.storedAt) <= self.timeToLive else {
            return nil
        }

        return entry.value
    }

    func set(_ value: Value, for key: Key) {
        self.entries[key] = CacheEntry(value: value, storedAt: self.clock.now)
    }

    func removeValue(for key: Key) {
        self.entries.removeValue(forKey: key)
    }

    func removeAll() {
        self.entries.removeAll()
    }
}
