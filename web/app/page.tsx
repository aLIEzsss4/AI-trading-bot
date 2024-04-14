"use client";
import { useState } from "react";
import { Button, Input, Radio } from "antd";

import "./style.css";

export default function Home() {
  const [link, setLink] = useState("");
  const [pool, setPool] = useState("");
  const [peopleNum, setPeopleNum] = useState(0);

  const onChangeLink = (val: string) => {
    setLink(val);
  };

  const onChangePool = (val: string) => {
    setPool(val);
  };

  return (
    <div className="p-4">
      <div className="text-right">
        <div className="inline-block">bot余额: 200ETH</div>
        <Button className="mx-5">存款</Button>
        <Button className="mx-5">取款</Button>
        <Button className="mx-5">链接钱包</Button>
      </div>
      <div className="flex mt-10">
        <div className="left-style">left</div>
        <div className="middle-style">
          <div className="dynamic-operation">
            <div>链: 在{link}上</div>
            <div>
              Token: 池子{pool} 人数{peopleNum}
            </div>
          </div>
        </div>
        <div className="right-style">
          <div>
            {/* <Icon type="link" /> */}
            <div className="link-title-style">链</div>
            <div>
              <Radio.Group
                buttonStyle="solid"
                onChange={(val) => {
                  onChangeLink(val.target.value);
                }}
              >
                <Radio.Button value="BTC">BTC</Radio.Button>
                <Radio.Button value="ETH">ETH</Radio.Button>
                <Radio.Button value="SOL">SOL</Radio.Button>
                <Radio.Button value="Doge">Doge</Radio.Button>
              </Radio.Group>
            </div>
            <div style={{ fontSize: 20 }} className="pb-8 pt-16">
              Token
            </div>
            <div className="mb-4">
              池子大小:
              <Input style={{ width: 100, marginLeft: 12 }} />
            </div>
            <div>
              参与人数:
              <Input style={{ width: 100, marginLeft: 12 }} />
            </div>
            <div style={{ fontSize: 20 }} className="pb-8 pt-16">
              操作
            </div>
            <div className="mb-4">
              <Button>购买</Button>
              <Button className="ml-4">出售</Button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
