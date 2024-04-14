import { Hono } from "hono";
import OpenAI from "openai";

const app = new Hono();

app.get("/", (c) => {
  return c.text("Hello Hono!");
});

// 1.fetch dex api token list

// 2.input user promot, output  strategy

app.post("/generate-strategy", (c) => {
  // const prompt = c.req.body.prompt;

  const apiKey = c.env?.OPENAI_API_KEY; // Replace with your actual API key
  const model = "gpt-4-turbo"; // Choose a supported model
  const prompt = "What's the weather like in Boston today?";

  const url = "https://api.gptapi.us/v1/chat/completions";
  const data = JSON.stringify({
    model,
    messages: [{ role: "user", content: prompt }],
    temperature: 0.7, // Adjust for desired creativity vs. accuracy (optional)
    max_tokens: 150, // Limit response length (optional)
  });


  console.log(apiKey,'apikey')

  fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: data,
  })
    .then((response) => response.json())
    .then((data) => {
      const chatCompletion = data.choices[0].text;
      console.log("Chat Completion:", chatCompletion);
      return c.json({ result: "create an author" }, 200)
    })
    .catch((error) => {
      console.error("Error:", error);
      return c.json({ result: "create an author" }, 400)
    });

  // return c.json({ result: "create an author" }, 200)

});

// push strategy

// struct Strategy {
//   address token;  // token的地址
//   uint256 ratio; // decimals 6 购买的比例，比如是10%仓位，就传入100000
//   bool buy;  // 买还是卖
//   uint256 timestamp;  // 购买的时间戳，s为单位
// }

// app.post

export default app;
