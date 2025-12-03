const std = @import("std");
const fetcher = @import("util/fetcher.zig");
const common = @import("util/common.zig");

pub fn part1(input: []const u8, debug: bool) !u64 {
    const allocator = std.testing.allocator;
    var result: u64 = 0;

    var ranges = std.mem.tokenizeScalar(u8, input, '\n');

    while (ranges.next()) |line| {
        if (debug) std.debug.print("Processing line: {s}\n", .{line});

        var batteries = try common.parseDigits(allocator, line);
        defer batteries.deinit(allocator);

        if (debug) std.debug.print("  Parsed digits: {any}\n", .{batteries.items});

        var best_val: u64 = 0;

        for (batteries.items, 0..) |first, i| {
            for (batteries.items[i + 1 ..]) |second| {
                const combined = first * 10 + second;
                if (combined > best_val) {
                    best_val = combined;
                }
            }
        }

        if (debug) std.debug.print("  Best combination: {}\n", .{best_val});

        result += best_val;

        if (debug) std.debug.print("  Running total: {}\n\n", .{result});
    }

    if (debug) std.debug.print("Final result: {}\n", .{result});

    return result;
}

pub fn part2(input: []const u8, debug: bool) !u64 {
    const allocator = std.testing.allocator;
    var result: u64 = 0;

    var ranges = std.mem.tokenizeScalar(u8, input, '\n');

    while (ranges.next()) |line| {
        if (debug) std.debug.print("Processing line: {s}\n", .{line});

        var batteries = try common.parseDigits(allocator, line);
        defer batteries.deinit(allocator);

        if (debug) std.debug.print("  Parsed digits: {any}\n", .{batteries.items});

        var selected = std.ArrayList(u8).empty;
        defer selected.deinit(allocator);

        var start_idx: usize = 0;
        while (selected.items.len < 12 and start_idx < batteries.items.len) {
            // Find the highest digit in remaining positions
            // Must leave enough digits for the remaining slots
            const remaining_needed = 12 - selected.items.len;
            const search_end = batteries.items.len - remaining_needed + 1;

            var max_digit: u8 = 0;
            var max_idx: usize = start_idx;

            var i = start_idx;
            while (i < search_end) : (i += 1) {
                if (batteries.items[i] > max_digit) {
                    max_digit = batteries.items[i];
                    max_idx = i;
                }
            }

            try selected.append(allocator, max_digit);
            start_idx = max_idx + 1;
        }

        var combined: u64 = 0;
        for (selected.items) |digit| {
            combined = combined * 10 + digit;
        }

        if (debug) std.debug.print("  Selected digits: {any}\n", .{selected.items});
        if (debug) std.debug.print("  Best combination: {}\n", .{combined});

        result += combined;

        if (debug) std.debug.print("  Running total: {}\n\n", .{result});
    }

    if (debug) std.debug.print("Final result: {}\n", .{result});

    return result;
}

test "day03 part1 - short example" {
    const test_input =
        \\987654321111111
        \\811111111111119
        \\234234234234278
        \\818181911112111
    ;
    try std.testing.expectEqual(@as(u64, 3121910778619), try part2(test_input, true));
}

test "day03 part1 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 3);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(u64, 16946), try part1(input, false));
}

test "day03 part2 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 3);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(u64, 12345), try part2(input, false));
}
