const std = @import("std");

pub fn getInput(allocator: std.mem.Allocator, day: u8) ![]u8 {
    const filename = try std.fmt.allocPrint(allocator, "src/data/day{d:0>2}.txt", .{day});
    defer allocator.free(filename);

    // Try to read cached file first
    if (std.fs.cwd().readFileAlloc(allocator, filename, 1024 * 1024)) |content| {
        return content;
    } else |err| {
        // Only fetch if file not found, otherwise propagate the error
        if (err != error.FileNotFound) return err;

        // File doesn't exist, fetch and cache it
        const content = try fetchInput(allocator, day);
        try std.fs.cwd().writeFile(.{ .sub_path = filename, .data = content });
        return content;
    }
}

pub fn fetchInput(allocator: std.mem.Allocator, day: u8) ![]u8 {
    // Read session cookie from file
    const session_raw = try std.fs.cwd().readFileAlloc(allocator, ".aoc_session", 1024);
    defer allocator.free(session_raw);

    // Trim whitespace from session cookie
    const session = std.mem.trim(u8, session_raw, &std.ascii.whitespace);

    std.debug.print("Session cookie: '{s}'\n", .{session});
    std.debug.print("Session cookie length: {d}\n", .{session.len});

    // Create HTTP client
    var client = std.http.Client{ .allocator = allocator };
    defer client.deinit();

    // Build URL
    const url = try std.fmt.allocPrint(allocator, "https://adventofcode.com/2025/day/{d}/input", .{day});
    defer allocator.free(url);

    // Build cookie header
    const cookie = try std.fmt.allocPrint(allocator, "session={s}", .{session});
    defer allocator.free(cookie);

    std.debug.print("Cookie header: '{s}'\n", .{cookie});

    // Set up headers with session cookie
    const headers = &[_]std.http.Header{
        .{ .name = "Cookie", .value = cookie },
    };

    // Create writer for response body
    var body: std.Io.Writer.Allocating = .init(allocator);
    defer body.deinit();

    const response = try client.fetch(.{
        .method = .GET,
        .location = .{ .url = url },
        .extra_headers = headers,
        .response_writer = &body.writer,
    });

    // Check if request was successful
    std.debug.print("HTTP Status: {}\n", .{response.status});
    if (response.status != .ok) {
        return error.FetchFailed;
    }

    return try body.toOwnedSlice();
}
