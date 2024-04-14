import "./style.css";
interface TokenInterface {
  token: string;
  isSelected?: boolean;
  onClick?: (val: string) => void
}

export const TokenBlock = ({ token, isSelected, onClick }: TokenInterface) => {
  const tokenStyle = isSelected ? "selected-style" : "block-style";
  const onTokenClick = (val: string) => {
    onClick(val);
  };
  return (
    <div className={tokenStyle} onClick={() => onTokenClick(token)}>
      {token}
    </div>
  );
};
