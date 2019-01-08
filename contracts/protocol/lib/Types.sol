/*

    Copyright 2018 dYdX Trading Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

*/

pragma solidity ^0.5.0;

import { SafeMath } from "openzeppelin-solidity/contracts/math/SafeMath.sol";
import { Math } from "./Math.sol";


/**
 * @title Types
 * @author dYdX
 *
 * TODO
 */
library Types {
    using Math for uint256;

    // ============ Par (Principal Amount) ============

    struct TotalPar {
        uint128 borrow;
        uint128 supply;
    }

    struct Par {
        bool sign;
        uint128 value;
    }

    function sub(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (Par memory)
    {
        return add(a, negative(b));
    }

    function add(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (Par memory)
    {
        Par memory result;
        if (a.sign == b.sign) {
            result.sign = a.sign;
            result.value = SafeMath.add(uint256(a.value), uint256(b.value)).to128();
        } else {
            if (a.value >= b.value) {
                result.sign = a.sign;
                result.value = SafeMath.sub(uint256(a.value), uint256(b.value)).to128();
            } else {
                result.sign = b.sign;
                result.value = SafeMath.sub(uint256(b.value), uint256(a.value)).to128();
            }
        }
        return result;
    }

    function equals(
        Par memory a,
        Par memory b
    )
        internal
        pure
        returns (bool)
    {
        if (a.value == 0 && b.value == 0) {
            return true;
        }
        return (a.value == b.value) && (a.sign == b.sign);
    }

    function negative(
        Par memory a
    )
        internal
        pure
        returns (Par memory)
    {
        return Par({
            sign: !a.sign,
            value: a.value
        });
    }

    function isNonPositive(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.value == 0 || !a.sign;
    }

    function isNonNegative(
        Par memory a
    )
        internal
        pure
        returns (bool)
    {
        return a.value == 0 || a.sign;
    }

    // ============ Wei (Token Amount) ============

    struct Wei {
        bool sign;
        uint256 value;
    }

    function sub(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (Wei memory)
    {
        return add(a, negative(b));
    }

    function add(
        Wei memory a,
        Wei memory b
    )
        internal
        pure
        returns (Wei memory)
    {
        Wei memory result;
        if (a.sign == b.sign) {
            result.sign = a.sign;
            result.value = SafeMath.add(a.value, b.value);
        } else {
            result.sign = (a.value >= b.value);
            if (a.value > b.value) {
                result.sign = a.sign;
                result.value = SafeMath.sub(a.value, b.value);
            } else {
                result.sign = b.sign;
                result.value = SafeMath.sub(b.value, a.value);
            }
        }
        return result;
    }

    function negative(
        Wei memory a
    )
        internal
        pure
        returns (Wei memory)
    {
        return Wei({
            sign: !a.sign,
            value: a.value
        });
    }
}