import { describe, expect, it } from "bun:test";
import app from ".";

describe("test hello", () => {
  it("Should return 200 Response", async () => {
    const req = new Request("http://localhost/");
    const res = await app.fetch(req);
    expect(res.status).toBe(200);
  });
});

describe("test generate-strategy", () => {
  it("Should return openai api json", async () => {
    const req = new Request("http://localhost/generate-strategy", {
      method: "POST",
      headers: {
        "Content-Type": "application/json", // Set content type for JSON data
      },
    });
    const res = await app.fetch(req);
    expect(res.status).toBe(200);
  });
});
