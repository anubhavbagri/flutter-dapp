// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract CreateNFT {
    uint256 private _tokenId = 0;
    mapping(uint256 => string) private _tokenURIs;

    function createTokenURI(string memory _tokenURI)
        public
        returns (uint256, string memory)
    {
        _tokenURIs[_tokenId] = _tokenURI;
        _tokenId++;
        return (_tokenId, _tokenURI);
    }

    function getTokenURI(uint256 _tId) public view returns (string memory) {
        string memory _currentURI = _tokenURIs[_tId];
        return _currentURI;
    }

    function getAllTokenURIs() public view returns (string[] memory) {
        string[] memory uris = new string[](_tokenId);
        for (uint256 i = 0; i < _tokenId; i++) {
            uris[i] = _tokenURIs[i];
        }

        return uris;
    }
}
