// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract JsonArray{
    string[] public jsonDataArray;

    function storeData(string memory _jsonData) public {
       jsonDataArray.push(_jsonData);
    }

    function getAllData() public view returns (string[] memory) {
        return jsonDataArray;
    }

    function getData(uint256 index) public view returns (string memory) {
        return jsonDataArray[index];
    }

    function getArrayLength() public view returns (uint256) {
        return jsonDataArray.length;
    }
}
