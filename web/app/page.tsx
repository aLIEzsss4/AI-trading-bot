"use client";
import { useState } from "react";
import { Button, Input, Table } from "antd";
import { TokenBlock } from "@/components/tokenBlock";

import "./style.css";
export default function Home() {
  const { Column } = Table;
  const [pool, setPool] = useState("");
  const [peopleNum, setPeopleNum] = useState("");
  const [tokenList, setTokenList] = useState(["sol", "doge", "sui"]);
  const [optList, setOptList] = useState(["购买", "取出"]);
  const [currentToken, setCurrentToken] = useState("");
  const [currentOpt, setCurrentOpt] = useState("");
  const [amount, setAmount] = useState("");
  const [showOpt, setShowOpt] = useState(false);

  const onChangePeople = (val: string) => {
    setPeopleNum(val);
  };

  const onChangePool = (val: string) => {
    setPool(val);
  };

  return (
    <div className="ai-container">
      <div className="top-left-block"></div>
      <div className="text-right">
        <div className="inline-block">bot余额: 200ETH</div>
        <Button className="mx-5">存款</Button>
        <Button className="mx-5">取款</Button>
        <Button className="mx-5">链接钱包</Button>
      </div>
      <div className="link-opt-container">
        <div className="middle-style">
          {showOpt ? (
            <div className="dynamic-operation">
              <div>你是一个专业的区块链交易员</div>
              <div>链: 在{currentToken}上</div>
              <div>
                Token: 池子{pool} 参与人数{peopleNum}
              </div>
              <div>操作方式:{currentOpt}</div>
              <div>现在开始工作吧</div>
              <div>具体怎么工作程序员会知道的</div>
              <div>是的....</div>
              <div>你只需要等待指令就好</div>
            </div>
          ) : <div className="empty-opt"></div>}
          <div style={{ padding: "20px 30px" }}>
            <Table className="table-container">
              <Column title="TOKEN" dataIndex="age" key="age" />
              <Column title="PRICE" dataIndex="age" key="age" />
              <Column title="TXNS" dataIndex="age" key="age" />
              <Column title="VOLUME" dataIndex="age" key="age" />
              <Column title="MAKERS" dataIndex="age" key="age" />
              <Column title="5M" dataIndex="age" key="age" />
              <Column title="1H" dataIndex="age" key="age" />
            </Table>
          </div>
        </div>
        <div className="right-style">
          <div>
            <div className="right-opt">
              <div className="link-title-style">链</div>
              <div className="token-list">
                {tokenList.map((o) => (
                  <TokenBlock
                    token={o}
                    isSelected={currentToken === o}
                    onClick={(val) => setCurrentToken(o)}
                  />
                ))}
              </div>
              <div className="token-title-style">Token</div>
              <div className="mb-4">
                池子大小:
                <Input
                  style={{ width: 100, marginLeft: 12 }}
                  onChange={(val) => onChangePool(val.target.value)}
                />
              </div>
              <div>
                参与人数:
                <Input
                  style={{ width: 100, marginLeft: 12 }}
                  onChange={(val) => onChangePeople(val.target.value)}
                />
              </div>
              <div className="opt-title-style">操作</div>
              <div className="token-list">
                {optList.map((o) => (
                  <TokenBlock
                    token={o}
                    isSelected={currentOpt === o}
                    onClick={(val) => setCurrentOpt(o)}
                  />
                ))}
              </div>
              <div className="opt-title-style">金额百分比</div>
              <div className="token-list">
                <Input
                  style={{ width: 100, marginLeft: 12 }}
                  onChange={(val) => setAmount(val.target.value)}
                />
              </div>
            </div>
            <div className="opt-text-container">
              <div className="opt-item">
                {currentToken && `在${currentToken}上`}
              </div>
              <div className="opt-item">
                {pool && `池子>${pool}`} {peopleNum && `参与人数>${peopleNum}`}
              </div>
              <div className="opt-item">{currentOpt && `${currentOpt}`}</div>
              <div className="opt-item">{amount && `${amount}%`}</div>
            </div>
            <div className="operation-style" onClick={() => setShowOpt(true)}>执行</div>
          </div>
        </div>
      </div>
    </div>
  );
}
