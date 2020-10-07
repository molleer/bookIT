import Styled from "styled-components";
import { DigitDesign } from "@cthit/react-digit-components";

export const Wrapper = Styled.div`
  display: flex;
  justify-content: center;
  align-items: flex-start;
  width: 100%;
  flex-wrap: wrap;
`;

export const ButtonRight = Styled(DigitDesign.CardButtons)`
  justify-content: right;
`;
