const std = @import("std");

pub fn parseDigits(allocator: std.mem.Allocator, str: []const u8) !std.ArrayList(u8) {
    var result = std.ArrayList(u8).empty;
    errdefer result.deinit(allocator);

    for (str) |char| {
        const digit = try std.fmt.parseInt(u8, &[_]u8{char}, 10);
        try result.append(allocator, digit);
    }

    return result;
}
