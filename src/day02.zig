const std = @import("std");
const fetcher = @import("util/fetcher.zig");

pub fn part1(input: []const u8, debug: bool) !u64 {
    var result: u64 = 0;

    var ranges = std.mem.tokenizeScalar(u8, input, ',');

    while (ranges.next()) |range_str| {
        var parts = std.mem.splitScalar(u8, range_str, '-');
        const start_str = std.mem.trim(u8, parts.next().?, &std.ascii.whitespace);
        const end_str = std.mem.trim(u8, parts.next().?, &std.ascii.whitespace);

        const start = try std.fmt.parseInt(u64, start_str, 10);
        const end = try std.fmt.parseInt(u64, end_str, 10);

        if (debug) std.debug.print("\nRange: {d}-{d}\n", .{ start, end });

        var num = start;
        while (num <= end) : (num += 1) {
            if (isInvalidId(num)) {
                result += num;
                if (debug) std.debug.print("Invalid ID: {d}\n", .{num});
            }
        }
    }

    return result;
}

fn isInvalidId(num: u64) bool {
    var buf: [32]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{d}", .{num}) catch return false;

    if (str.len % 2 != 0) return false;

    const half_len = str.len / 2;
    const first_half = str[0..half_len];
    const second_half = str[half_len..];

    return std.mem.eql(u8, first_half, second_half);
}

pub fn part2(input: []const u8, debug: bool) !u64 {
    var result: u64 = 0;

    var ranges = std.mem.tokenizeScalar(u8, input, ',');

    while (ranges.next()) |range_str| {
        var parts = std.mem.splitScalar(u8, range_str, '-');
        const start_str = std.mem.trim(u8, parts.next().?, &std.ascii.whitespace);
        const end_str = std.mem.trim(u8, parts.next().?, &std.ascii.whitespace);

        const start = try std.fmt.parseInt(u64, start_str, 10);
        const end = try std.fmt.parseInt(u64, end_str, 10);

        if (debug) std.debug.print("\nRange: {d}-{d}\n", .{ start, end });

        var num = start;
        while (num <= end) : (num += 1) {
            if (isInvalidIdRepeating(num)) {
                result += num;
                if (debug) std.debug.print("Invalid ID: {d}\n", .{num});
            }
        }
    }

    return result;
}

fn isInvalidIdRepeating(num: u64) bool {
    var buf: [32]u8 = undefined;
    const str = std.fmt.bufPrint(&buf, "{d}", .{num}) catch return false;

    var pattern_len: usize = 1;
    while (pattern_len <= str.len / 2) : (pattern_len += 1) {
        if (str.len % pattern_len != 0) continue;

        const pattern = str[0..pattern_len];
        var is_repeated = true;

        var pos: usize = pattern_len;
        while (pos + pattern_len <= str.len) : (pos += pattern_len) {
            const chunk = str[pos .. pos + pattern_len];
            if (!std.mem.eql(u8, pattern, chunk)) {
                is_repeated = false;
                break;
            }
        }

        if (is_repeated and (str.len / pattern_len) >= 2 and (pos == str.len)) {
            return true;
        }
    }

    return false;
}

test "day02 part1 - short example" {
    const test_input =
        \\11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    ;
    try std.testing.expectEqual(@as(u64, 4174379265), try part2(test_input, true));
}

test "day02 part1 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 2);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(u64, 12345), try part1(input, false));
}

test "day02 part2 - full input" {
    const allocator = std.testing.allocator;
    const input = try fetcher.getInput(allocator, 2);
    defer allocator.free(input);

    try std.testing.expectEqual(@as(u64, 12345), try part2(input, false));
}
