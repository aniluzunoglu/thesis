{{
  "language": "Solidity",
  "settings": {
    "evmVersion": "istanbul",
    "libraries": {},
    "metadata": {
      "bytecodeHash": "ipfs",
      "useLiteralContent": true
    },
    "optimizer": {
      "enabled": true,
      "runs": 200
    },
    "remappings": [],
    "outputSelection": {
      "*": {
        "*": [
          "evm.bytecode",
          "evm.deployedBytecode",
          "devdoc",
          "userdoc",
          "metadata",
          "abi"
        ]
      }
    }
  },
  "sources": {
    "contracts/Libraries/AssetRenderer5.sol": {
      "content": "// SPDX-License-Identifier: MIT\r\npragma solidity >=0.4.22 <0.9.0;\r\n\r\nlibrary AssetRenderer5 {\r\n\r\n    /**\r\n    * @notice render a weapon asset\r\n    * @param lgAssetId the large asset id of the gear item\r\n    * @return string of base64-encoded image\r\n    */\r\n    function renderWeapon(uint256 lgAssetId)\r\n        external\r\n        pure\r\n        returns (string memory)\r\n    {\r\n        string[29] memory WEAPONS = [\r\n            // START WEAPONS\r\n            // 0 brass knuckles\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAANhJREFUeNrs27sNwyAQgGEu8gS0NLCXx2MGWtcuPAEbsIQTpBg5rw6InfzXICgOfUJcdSfruqpfj4v6gwAJEiRIkCBBggQJEiRIkCBBggQJEiRIkCBBggQJEiRIkCBBggQJEiRIkCBBggR52hhqJhvH8aFD2HsvR0BKrc7lDHTOlb21Vk3TdAjs0CJpBhpjMvzlhb8Blpo96HvMBnyOG7I7VFo12m/gd9jeUGk9TbDHxhjL+TzP3aDSa2QiY/fQlJJalkWFEOSUhefDX5T7Wqqw1rrL3VcBBgAXRk2XfNaHnAAAAABJRU5ErkJggg==',\r\n            // 1 pickaxe\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAX9JREFUeNrs2jFLw0AUB/B3V0ulUJG6FYdayJrBwVk/R/Jh/Ca65DOELtq5g4UMXQrSRRwUFcWhg5y+KwchLfRaB/PO/4OjR0tKfnnvLtdelDGGQg9N/yCABBJIIIEEEkgggQQSSCCBBBJIIIEEEkgggQQSSCCBBLL+sbfLQWma2k3NLMuUhP1NvQswjmPbF7OByyfq25IkMXmeG37d9ti/bHqbDP40KooizInHATkYKWUseiOrwKBvIWWgtCdGtG8Wg18MuCy68RgMUvJs+uvFgMQnuLRvFqWWqtfaNehyZRy35nRoG8f5SccEgazeNjrHmk7P2hQ9jqh/2KKLwYHhJr5cXYlyBj+40yPqRg3qUpv6sxbNXxfkoLf370r0mJy/LZad8TKjUW9fJHZloc3lWp5F+XOGcKm68mWsi5fZl8W6C1JH7ApSqfXn6CadTdiruycZyPJ7VfQ67NFnky5vHlRdFwsbfxf6ZPZ68my/p3qBxCBDCPzvCqSg+BZgALDGXYBnH6DbAAAAAElFTkSuQmCC',\r\n            // 2 shadowblades\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAb5JREFUeNrsmTGOgzAQRTHiAjQgUdOGLieg5QZ03C03oOUEdKShSB0pnAGJzSA5GlkGAizgZf80FgmW5/l/2wOIruuss4dt/YMAJCABCUhAAhKQgAQkIAEJSEACEpCABCQgAQlIQAISkIAEJCABCci9wjlqYCFE314ul/5T9/1+F1t99XZMmOk3KDVEKE5lV1JNKvd6vXrQKIq6065J3/c/is4Fpfun+hgBSUpy684F9TxvtI9RSlJcr9dF/ccmxzgll6gp+w/1M+6cLMtytprcCTrQUxQD3Am6CTIWcs2Rova1TVTjt+2O2nVtDNmtqqrJ8o3UeNezs5yg24BoLGdLQDqk+Q4obSQH5/fwBP+EkjL5oig+isVx3NF6ociybLM6dVe7ckB+TUV5mqZdEARW27aDKsoJWXJWqnbfZOOhZ0Pd04aM2+0mns+ndndV2zlLYnclVTB+rSYnNw3ZPh6PVSruUgx8+4TfNI0WNAzD/j/uiCkVVQfkeX7cOcmTU622VMkpJxhXDLiuO+kI3VpUncAtbB+l4ljUdT3b7qoTaGeVdt9dSUpCTU7+niTJJ/mx9cjfCIzVwNIJPwIMANQO9dNShroWAAAAAElFTkSuQmCC',\r\n            // 3 kusarigama\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAhJJREFUeNrsmr9PAjEUx9vzTESCRt2MCyZswmCMMy4aV1f4A5xcWRxd/A/8A2B1cJFNJwcHB1YSdVA2jZH4K0Yr77iSR3MHeCA0+H1J0165Nnz6fe+1l1QqpcS4myP+gQESkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQgAQlIQAISkIAEJCABCUhAjq25Nv0ZKaXQV26orU335fP50Ps4pVJJ8netheSwHFDDNepOw5Q/VpqgctSXlcLU05bL5VQXuDYrFostZfW8I1eSL7K54KRgL4CVSqXVzmQyXqHptKpWuuvG8oxHu727HwrTrd9fHJpHujYCpldiIrU4Jd58AFLGBOHPOulwB+G/S5suEJJ73l+ciJ3NOe/5sfolYlt7PYFxDjNxuTYBkosdNiAJbj41IR7in2KJwXUCM/s5qHXuSnF4enQg0vGmyx432uc3ddkNrFNCs+rEQ4pp1ep3314dm3fEbwGtPtb5qd9T7vbpo6ns2qzIJhOqn9zh9htHbBOWg1CS29Xlq1hdn25Tc6hKEiCtPCULqoNOK1GVJNW0mtXau6em3juHBqkzIa08HaMKhYIcVEya8RcUm3/urlpBggvYhPtWkoOSmtmkUIma01Lz7PpZDkVJ7la8DDomuZrktlHVdGxRUbu/Oa+ZaaPEphNVxbBPoyifWuVyWfGFoz5dtC28TLaNCStB9iPAAAMvFtd8U1D+AAAAAElFTkSuQmCC',\r\n            // 4 phoenix blade\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAcBJREFUeNrs2rFOwzAQBuC4ilQmwtwZxk70JcJbMLDyPoh3YO1LwMQIE0P3bjCZ/lEuuFe7juUmRPCf1CFRYvvz2ZdUirHWFn89ZsU/CCKJJJJIIokkkkgiiSSSSCKJJJJIIokkkkgiiSSSSCKJJJJIIokkkkgiiZx4lCkX36wuol82rV+2ZmofQJUpsHpVdefvlj+Qx1fj3mJ390wKHRyA4ABzQSkB/Pp5++tgb6cAujiVqV7hy7SAx8YedCbAU8UUsN2eNMYU9XVlLxfz4m3z2buBq8VZdMkegqumj7qorEHH2MgDYjukAFPDNyEhuIAb7HK+O26us+0kD5bVver6vvlKujk0KRqu0XtYldUhoF2j7apJCmRfYzFRPnwou25xw17FPtXX5ML3kLHGfBMh0GOZjWFj0FzkLKUhXOP+ZB/jh4Ehi3rJ62PfHnaXLyq7O3GDvgz0eRN6uj1vBnj/8GFiyzgno7mZLHNu1kBn6TfnUExCWMmoi0V7gEpBQpO+PToqUgaqZxrHcMoAgRWoLkxoIwbNrbplMUIAK9BQVjXUfcS0z1KTXXhOHVKcXOix53CoIEkx6vM3LxTfAgwAuBAia6t2+pUAAAAASUVORK5CYII=',\r\n            // 5 none\r\n            '',\r\n            // 6 rusty sword\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAASdJREFUeNrsmosJhDAQRN0jXViNdWh5WofVWEfOPVS8nJII52cnExBBEHy+bDKJive+QG+vIoNGSEISkpCEJCQhCUlIQhKSkIQ8F7JpGi8i+CbruoYDdeGFqqr0pKBJpBa2T9zWxbHbfp6/67ooaPgungi9O/AoqHZd+NEVBTQ6hSCAbkIOwwAFumsSCfQLUkfTvu/hQA/HOougP5Axm3NgsASa7yokZrMsS1M2szAp66wZ5lA1NQX2xWA4zajxlIx7Z7blzgBKbdIkik2aRLFJkyg2aTJsbduatOnujlyP7K4WazOLmnRHb9AuPX1CWFYoanO9QpltFom78DR5h0mLNmkSxSYTD8q8yZo8YjO1NsdDaPKEJv8M5fqLTMo+ra5mroR8CzAAlOHbWwh1ahQAAAAASUVORK5CYII=',\r\n            // 7 bronze sword\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAVVJREFUeNrsmEEOwUAUhmdkdhK1cgNLKy6hDuAETsGSUzgBe1yitbHTE7BSiZ1kGDJoaVTS4r3+L5k0bSZNvn7zOm+e1FoL7lESBQhAAhKQgAQkIAEJSEACEpCABGS+kIOOo6WU/E323Qo7UBV/0G2VzcWApiKl0D6JmFxurlwD17kYTfMC8y0eB4nlOl1/Dkry7zpe8QJN3EI4gb6E3IZHVqCJJi3obQ8lDBqBXPih9INDBNTapAz6cVlHEfQJ8p1NWzBQAi3uKeSdzXpNkbJZCJPyscCO157tpqOb9fLtvuYo0Wvc5wfbo5h4BzGa71MXrb8o6NEZ4JKbMMnFJkxysQmTXGzCZDzm3o6kTfXrkusvlyvF3EROJp0iqNmESS42YZKLTZjksm8WwqTK4iXGpklT29m72rx39qxNM+c8JEzmEDLLotxtVVP1aYez8Ks2TwIMANdQ/b4gmemwAAAAAElFTkSuQmCC',\r\n            // 8 holy sword\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAW1JREFUeNrsmc1qwkAURu8tWQgF3RW66K76BH2Kui6Ci76HtVAFf96ji0Lpppv6FN24VXfduVMQWhCmTnWCiRVnoGrvzTcQQkISODlzM99M2BhD2tsJZaABEpCABCQgAQlIQAISkIAEJCD3C9m4Y8PM+k0+1EgdaJQ+Ub352VlQL1IJyycJk/N+ftlta0ujPg+w72J9E9Fdv17Pg0FFfl0/Hy9UgW4dQjSB/go5HM9VgW416UDjMVQwaAKy3Zvy8/ssAepsSgYNjnUSQTcgd9l0gUESaHZnIbtsli5l2cyESV4P2OnsWb/Om8rVaXxcPIsod/sRHw9GRE8vRM0ueYfWYwR6rAxoqU2Y1GITJrXYhEktNmEy3VpvE5E2o2NHrn/ZXSXWZiZqMgq9wXbp1S+EeIZibRYXNt0Mxdm014TMUGDykCYl2oRJLTaReLSMm6jJEJu+tbnYGCb30PgvQ/l9ueC1TtvomIPa/BZgAE9a8+L8u4WmAAAAAElFTkSuQmCC',\r\n            // 9 bronze daggers\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAaNJREFUeNrsmrFuwjAURW2rUtjSmbGCkanMXRFVf6M/wy/wGwj2zu3Ukaojc7vB5PISHB4IWttxXlS4liIYIj8f3+PElqKtterSm1FX0AAJSEACEpCABCQgAQlIQAISkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABOR1Qt743vg4vK0+E1m8fev/9NVIUJK9blZc4/vccuiLSdK1pzulZiqr0p2/fmmpwfKJDanrnSQp+rHaqNlnCToZlalKJ+psorq+tYN05aAvy80BqNZigRaTzGGTQZ570DhQWqdNw5GiMTYFJUmgPM1jUIlEY2yq9Z6kIqcSlVTXxyaTYjYlW4xNpokHgmSaPjYlhXzoZ2KJhthUG/K4SL/baXV3c8omk6JTvjaeB1bsleJrk0mhC4FO33Vr6f1lUzAkPd3cxYtQgm0p+5tNpKxJVYQnSUXGw7zxfa2vTUGnkHODLmdxraZqn+Byta51cvDdYm77r8YwGR3aRBMQddQiDVwnXNFd+f3fQbad2U4F6wo2qSwl6cZU/ubFoIIhQ9ebuz8VZIxNPwIMAM/39ASfB+UaAAAAAElFTkSuQmCC',\r\n            // 10 holy daggers\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAc1JREFUeNrsmjFOwzAUhp+jiHaiWzbGHoOIqUO4A1fgAJSpcBHuUCRYisIxOrJ1I1PLYvJcObhRC3biOKL9nxQpkaz8+fx+Pz9LEVJKOvaI6AQCkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQgAQlIQAISkIAEJCABCUhAniZkbDtwej2qfhN5fC7Ef/prJHYZnI6H25uMZAlND/NPcXSQHGeTFaWUVNkNCWq6yUXXek2yRfPlmr5eEwU6ma1UZk3hEMGaWtdW26nwmKBv77QDKkQ45yo3GbDeIA8VGg16l513nlG2aCM38ce7XBwM9HKbSFlQdfGzBnV9Z1P9xdxOO24zs2zZq8ufjNJ9oipvad2gW4ypXT4KL81AfW2GDJ48U7++bPbVh9h7QaCw2bRxk9e2TouFCBc3tYasi6TjQa/djd5euBBp20Y+XmqujeHNR7AtxdZNkQ+7MOj66aK37P3lJmfI+p6lRTiDfVn2NzexZSNfImYmWWSajTrva23d5LSFHPpoFslpQ6khki83rU4Oti0mH/kqN8123cQT0Gif1GdKfsnWosX+LoTHlNAaVgt2aVnOpF42yk2kJl02gBw0Gu8LsombvgUYAEB2jLqBBdg1AAAAAElFTkSuQmCC',\r\n            // 11 soul daggers\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAbxJREFUeNrsmr1OwzAUhW0rEuIdWDpkZWjEloVuzcg7hI2FB+nSDd6hY9lgYUPtwJqhC++AmEJuisNtS8F2HEe050pVO1g9/u458Y8UWZalOPRS4ggKkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQgAQlIQAISkIAEJCABCUhAHidkZDpwlF03r4k8PdzL//TWSGQzeBAPv37lZQUtHud38uAgqa7OTsRMDBt3Q4LyNNnoGj+TFNFVsRSzt48adJKltbNcOESRptY11bZaeDjo8+vLBqiU4ZJLTeaw3iD3LTQa9HKcd+4oRdQlTVZOEih3cxs0hKMuaWq1T5LIT46GjK5JmpSPboYslzRFvheE9fZSuxnkwEBNTs8vGtDbudjR93qs02IhyiZNrSG3RQZx0uvpRm8vfG1QXiLKno2b+DTYlmKaJuUjLgQ6Ld57c++vNFlD0sOsP1yEHOwrsr+liSKrfIlwJ0lklOWdn2tN02S1heyb9LqLCzEV3w6uikWrm4PpEZOufHoOk2wzTdQAp31S3ynpT3hEdypOq84mDawW7DKy5KSeU/1dpYl64gCZOI33BemSpk8BBgBS2xHKk2R9CQAAAABJRU5ErkJggg==',\r\n            // 12 holy bow\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAbZJREFUeNrsmr1Ow0AMx++iSAxIdGNj42NEQn2KsLDxMGQAiY9n4QHoU/AE0B2JjUpsSEcc5Cq9XpO0dyi2Y0s3ROryy9/+2+fUOueM9MjMCEIhFVIhFVIhFVIhRw6ZNx/Ky0k94z3MFjb0Y64j4JqSZTExN8WBE6skKJifL1xZHNXCbVKUNSTG++dPrSiA3r98sQfNQjW3d/WxBMU6Femuz6/fK6DWWuMf9pBVba6kLmczau2ToKYE0FZIcFcE5dxeOiceBAU1RbWQECiY7/V0f9laOPXQoJKnx4JnV4y3eT81q2NFK8lpUNjqquWbEBfQre+THN12p0tzs39yULMVEgb2TQcnIdHrD05qRu94OKi5M6S/76GsZpJtHXU1oyBDtxSKakZBNlOWsprR6eqrKbYmqRtQNCSHlNUPPn0DFtCUXVaVTGFAFJbQWd/1B+fpJ9kiy69L8pAxSnYN8uKMp97sEXDZf4HEujw5zOmma6p+Oao+OXQbCebT2cXfZvz2MU1dgv9UoHYoE1pT8u7JiPgzRKeSKd84mA+qaQb6dpKlBkTzoTT56ICeMmVVSYWMj18BBgBBAfIoY/ffzAAAAABJRU5ErkJggg==',\r\n            // 13 shadow bow\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAZFJREFUeNrsmjESgkAMRQljS0lDxQXgmNyJa8AF6BkqDoDGmTi4rojuKklMZrbQsXn+5CcbgGVZEu2RJn8QBmmQBmmQBmmQBvnnkKf1h7qurzNe3/fg+7HUEfBByaqq8Cxq0xUVnKZJHejJ9+U8z1dQzNCu60CVklRzCEigVKcq3XUYhjtQAEjcIx6yKIq71JVco5t9EtXUALoJiW5LoJLby8uJh0BRTVUtxAeK5luW5a21PJuKxCiZ57ne2ZViHMddal4OqFZS0qDw1lXLNSEpoG/fJyW67UeX5nX/lKDmJiQO7M8OTUKq1x+S1Aze8UhQ82NId9/DWc0o2zruagZB+m4pHNUMglynLGc1g9PVVVNtTXI3oGBICSlrD3z2Bi6gObusKRnDgDgsodO96w/J00+0RZZbl+whQ5R8NcirMx7c7HFw2a9AUl1mWabPXbnW5U/65NFtxLtBb5oGYtYl+s8FFI4yoQcl27YV/47ALiVj/uNoPqRmctCzkzQ2IJkPp8nHBvSYKWtKGmR4nAUYAM9Y8XxdtZLpAAAAAElFTkSuQmCC',\r\n            // 14 genesis bow\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAcBJREFUeNrsmrFOAkEQhnfJmZAckZIYrZHe+BIEa9/A3nfwQWy0NtEXoKaAUqXFGEsNJBYmJ4MZchzLcbBrbmZuNrkCQsHHP/PPf3PYJEmM9FMzFTgKqZAKqZAKqZAKWXHIKP3iotNcZLynly/r+jDXCLimZK/TNL3Tw0RsuYKCN3FdHGjkevNj+rMAhQp9fP60opTEnnu4bC9BsU9FuutgMlsBtdaa7MUecnTWWildzj2aOydBTQmguZDgtgjKebxsTTwICmqKGiEuUDDf85N4OVo2pSI2StaPY7nZFc/326yQmvPLilaSU1DY6VYra0JcQJ2Q190DUW67101zen5yUDMXEgL7pguTkOj1Byc1vXc8HNTcGzK776GsZpBtHXU1vSBddykU1fSCTJcsZTW9yzWrptiepG5A3pAcSlYf+BQ9sICm7LKqZAgDorCEdkK+v05FpR8n5FG74d2X5CF9lNwW5MlA3vbDlBxs9ii47L8YD/ZlqxHRLddQ87JSc7LsMeKsp+FV/+9b3YXpS/CfOagty4TWlJzcj9n/R6CQkiF/cTAfVNOU9OykFhoQzYdS8tGAHrJkVUmF9D+/AgwAs5/02YmME18AAAAASUVORK5CYII=',\r\n            // 15 bronze staff\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAXBJREFUeNrs2TFuwkAQBdBdZKUgAiMhJTXpXcEBnNKU1LQ5Q+7AFbgBF0jLBVzRQUENEgVCuLKy8SxsMEQCO4mQZvynsZHdPM3uzKzRxhglPWqqAgEkkEACeffwyrzc77Vsv/mIt5pT6/HKAKOe734anQUX6E1kZlFR17fAt8ChfFbQm8ifQHW85wMtVHjyQPGF5xK+3j7abNKqZos8FZvzTI5nOgOmcvukAz75nszlulinGVBboOhMYqzjiqRlSfuQYjLXMpGcCsyfMlmZPemWLMfMFkbShMOtdfwqk24I4AYt1UIckNuSvYqkLwDxYv+ductM0jN6R0wm81BRR63jYVi/vjRN8FxX7bqnNskBOVslarrcaVF7koDvg5q9VubQnMs0BnQggQQSSCArj3STDsco/Ulyk3yyQxb+s8bNr/m5VdTEQ8Cw01Sj4YOdXek+7DSM6D3JbX+iugIJJJBAAgkkkEACCSSQQP57fAkwABKgngHgRL4dAAAAAElFTkSuQmCC',\r\n            // 16 holy staff\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAVhJREFUeNrs2TsOgkAQBuDFUJiYaGdiYekNPAUegM6LSKkXsbOz0VN4ArGzo5PERBMTZNBV2UJYSIwz/FOB0nyZ3Zl9OEmSKOnRUg0IIIEEEsifh2vzcTDpZf1msY0dTq3HtQEGXk+/Jk4aXKCFyNSiZl43A7anxwdYDVlBC5EmkIKeOUFLFZ5PoPjCY8L9aJBlk0Y1W+S72MS53y/LoQqjm9w+qYGjvitzuO4PSl2fQNGZxLKOK5KGJc1Diut6IBPJqcDUymRj5qQeshwzWxpJKxxuraNSJkOGPdK6hWggtyH7FUknAKvd+ZU5M5P0H30jJpOfUFFzkjbD880py6ZZWblk0SqTBNQVtjGbZp1pLNCBBBJIIIEEkvfmudKRJLcofVlDp+n+uJNbt4q5utNAfbNFm+fnPeXf34HUmpOiTwbQQoAEEkgggQQSSCCBBBJIIMvEXYABAPzeoLvJeT1tAAAAAElFTkSuQmCC',\r\n            // 17 shadow staff\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAATVJREFUeNrs2bENgzAQBVCIaNmBBaBj/wHoYAF6SgZwOItDxIqCDRLKP/5ViaB5+rbPxrlzLrNer+wBRSSRRBJ5exUpLzdN4/vNMAw5UuspUoB1Xetfly+FAj1ELpZswXlg27b7RzDQQ+Q34O43BDRq4QkStL3whPB5nn2aMqphkcFis1XXdQq02ScVWJalTeQ0TRvQdJLc1qEiZVjKPFy3czaRSAvMpSQfMyd1yCImG42UHQ5a6ziVJGKPTG4hCkQbsj+R8gVgHMctuTBJeSbvmElyDzU1J+Uw3Pe9TzNcWVFSTEpSgLrCPubQrElzg04kkUQSSSSR2IfnU58k0Sr6ska+pldV9bFvNXN1p0C92ZLD83p18Pd3IJfmpOkvA2whRBJJJJFEEkkkkUQSSSSRMfUWYAAGQqCvXabbLAAAAABJRU5ErkJggg==',\r\n            // 18 polished scepter\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAVdJREFUeNrs2jEOgkAQBdBd3c5ErLyBpRWUXgBLb2DhKTwKd7D1FFSU3sCOws5kZZCNqxEFpGDGPwkhUPnymd2RoK21SnqN1B8UkEACCSSQQAIJJJBAAgkkkEACCSSQQAIJJJBAAgmkhFpHM0vH630jBUfncDFR6ekiL0kCxlGgDtupmgdG3uPqgLulldmTTYFskQSk/vOBSabVOb/KSrKu/0Qg26bINsk2KbLdJym1JDNP16InHh9Ig8AxzTWrJLXWb28XR9mXftUBWSe5X43L3iTcJyC7nozDoFxSaYTzV1QHrPu6zHAC0oTjYHR2CX77dI5VkrQ30qqaZPdtpOpLW/UpfyQltilA9Kg+hoBmP5/V4+r3ovvf+GnBYT0MfFtNWW4hrym2rZH0FFkgf02RXZJdUhw8so8UWSXZNcVBI+kNQB8pskjSn1FFIf0U277qeFc3AQYAB7+0h6in7acAAAAASUVORK5CYII=',\r\n            // 19 ancient scepter\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAVRJREFUeNrs2rEKwjAQBuCkCkLBgjo4KziKr1AXH8DHdfIdHDt0dtBBwUmJXmwllra2tYN3/geltNvHf0nOojbGKOnlqT8oIIEEEkgggQQSSCCBBBJIIIEEEkgggQQSSCCBBBJICbWcBoau7PuuFBzd52Nf7fYXJQ5JwHASqOGso47RTV67ukCRa7IqkC2SgLT+XCC16uFylZXkyK++nXjSU2SbZJ0U2R4hNrUo8yx54nGBNAhs47NmlaTWOvf147Lr0q0iIOuJZ7bo2Q1nG5/scxGQHTKc9O2Mul4N3nbUFFj077IuJyBNOCmM7mmLfvrrHKsk7dkYPc9FOkaSdWmSdcofaVtyowy16qsiYecktau7FtPfjWUbDuvdtey4YDsMZFOsW570FFkgv02RXZJNUvx5ZBspskqyaYo/jaQvAG2kyCJJd0YVhXRTrPupI6/uAgwAniy3YrjrwnkAAAAASUVORK5CYII=',\r\n            // 20 club\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAeVJREFUeNrs2jlPw0AQBeC1AXEpEkeHKEKRDhoKav451BT8gUiQAtFxiAhEhCDoGT1r7Hh9NHgCb5rEjpTk8+zMjqMk8/k8/PVIwz8IIYUUUkghhRRSSCGFFFJIIYUUUkghhRRSSCGFFFJIIYUUUkghhRRyIVarTiZJUjg+PxpE/z1xeTtNunxgH3/ESKo+lEjiTo43C6+PDjbC9dVb9nzyPCtg6xB4X1dIAIc76/m5wWGa4RCP48/wsP2xgG2C9oVsXZMEIvZGK2H/dS2M79/DcPfnQuCCMPPl5e6y8dgsnp5tZRBmzEKnd1/ZI6FL212BA6QqcAGIzy6GyebSbSGoQSDwWA5kEfWJ11C3sQ7tHjl5muVLFJlDLZaXLevWYzZbNx7gmFGgLBTncCG8ZrPzxEMowkJtF/aWzTQ2xXCTt4HaK28phALO2rTd1kM2O2eSEDYhYAHFMfZOdmJP2UzrZtJyNtlgCOFAYM8R72nvrM1kDAoYUJx8uGwJZTdmNvteso3LNQblEGChPM5HPSfZbFWTsUZkRz27raBu2aQ8ZLN144lBuUyRtfL+6SWbnbprXY3G7lY8dNram+ZY8Avb+00bdupBvaIR8X7T3S8DTVGF5cBOIJ5z6wH04ubl14vzW4ABAN8HHrujN7U3AAAAAElFTkSuQmCC',\r\n            // 21 dual shortswords\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAWJJREFUeNrsmkGKhDAQRZOQK7hwK+jSi3gEPZ4eQQ+j4NYLuM9QDhkaWjqJ3ZmUM79ADBJKX/38UlFpjBF/PZT4BwFIQAISkIAEJCABCUhAAhKQgAQkIAEJSEACEpCABCQgAQlIQAISkCwgm6YxXdcZKaW4unEI7ZqQZZlo2/b45t73vbyjktpnEoHmeS5I1TvCenmyLEtR1zVB2n2yvymshT4Oue/7z5ggU4PSyqLz+16DF+S2bafHUzYcArXFdsG+hJymSc7zfIzXdX1S0zakFBFiIe/75LIsrJpJiIWckFzVDLGQE/LxtzQOal4puoqV+DfCt+j6SuKiKJIpSStLfrdvU1XVUXR7PVRwO20YBhnceDipGWohFXOZcPGmim16Dt5UsU3PQU0Vc5lwUVO/mzhlp7VFd3VaHSsxPXykUPOs6Cq26Tl4U8VKnOp986zoKrbpOaj5FuQ4jrdQ80uAAQAbKgRqdtaMpAAAAABJRU5ErkJggg==',\r\n            // 22 dual handaxes\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAnRJREFUeNrsmb8vg0EYx+89Er+iwViWim50EDGYajEYDNZ29KfYbCZ/QJuYDBZhYZIwGEpiaKIGbEraRIlwPC9P8/Z674/24t7D8ySXXt/m23w//d7d+97VEUKwv16c/YMiSIIkSIIkSIIkSIIkSIIkSIIkSIIkSIIkSIIkSIIkSIIkyD8B6ThOYMvn80K+xnXEQS3OyuVyAlqTDf/VAmNB/3ABJPYLhYJja9Lg87OxUqnkto4hZbFtsOAxk8m4fXwFr5Eg/cTQbAEF/zBE0R8WvOdRxN5COBBD8w7juOehChC8ch2xbaAqj13dQrxiBDVdy3MjAppqOske2yA7FXuvm0pzcTIhppJ9DBr0o3jsxU42NeyK8YvGF1ZYFMCwz36i6jfvbHZ+0O1XI/jgsjid7Gcz0wORIfC6qTQPr2rO9eMLK989u15vj3dDPTYhjyr1jsVy0iYLAoFaXRpt+bFVHrmOGBcek0NVDgTqcnsj0CPXEatuLSaGLD60YCA4P/08ch1xGLTJNBv7m75+uI5YXnxMlhzIWLrH1yPXEasATd4zMRAsCETlkeuI/R4MTKd5dvrUDETlkeuI/e6Zcay0WCcba21+uI7YhpIDUXnkOmJbyrtYwqjzBhK6CwkT25YmLpZHlVp0yDCxjWni09re1npzgx96/AHXYYeCj3k7Bw8Mdih+q2pcRyLoM5tKsPuhV3Z+0XDBW7ZaYVUtv7liqGKxqIIQcQ9Z5+usRsAu6nsnJWDX0qsjln5JB49L4h66ML2GJ3j7prkbsWr+Am/caWZTn4FMfAUCBwA8qtg7sVH8G1bajg6yVGJbC08PMJAPAQYAfd4Z6gyxGIoAAAAASUVORK5CYII=',\r\n            // 23 bronze shortsword\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAATFJREFUeNrs2jEKwjAYhuE/Wmgn69xZcXJzdreew1O0o7fwGoqncHJUHLvXqU6RRCiCiKQJNH/8AoUOUnx4G2lihZSSQh8D+oMBJJBAAgkkkEACCSSQQAIJJJBAAgkkkEACCSSQQAIJJJBAAukdMl+MZblOpRCCuh59jcjkw/dhQkVO+v/37aE2+tZ9Io1vVwVdThNSVdUR5JycZgoZU5mnLTY45Cxp2nOF5QA1Ru5v3+ecbz84xsjjqRbX6qHPd2fxUbPIRzKYkmpcqibchwGuNY2Q76+ocappfLtyrGn17MqlZickt5rWqxAONTsjOdV0sp70vaYVkktNZzsDPteMbC+gaq4olZMs1jU3c9nWfG0p6EW2CKKkzzWdIH/Nzb7Xm85363ysGbm6kM9z8ynAAIAhhYiPD/6GAAAAAElFTkSuQmCC',\r\n            // 24 poisoned spear\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAYVJREFUeNrsmb1KA1EQhedqJGKxYsRGELLCtRC0srOJIAipbINP4YOIrT5AbLQStBQrCxFB8Ae8hYEESxMISILoNbOwsgY02e1mcqa5P93HmTk7O9d470l7jNEIBCD7Y2FnyRtjxEHm0gBOrxZ6O8tFbNQqGazM6k3XWMXd8kRvb6OzSiWlqpjJXVlNdZAbi4HffGrS1t7dzx2nriSnHVrJgh2n/fMPkak7FGRxJk9v7pMqp/cRqLSUTaWk1MgNqsdSGPzxWbG8iGgMBipZa3Z/nTllpblspgY9NiBVvWt/Pa4d3NDDlNWh5OVL29RaXbq9fif32onueL1YD3UpyaClkHyR8uSoQ+3GF80dPtIJLetQkkcjGsYjqYzHzk+KbNgzjz/qVUeNI2dUQXJrl1zr1WejXknV/5PJDkiKKUHJ/+KYtr16SEn9a2bIq/IZ3BWQgAQkIAEJSEACEpCABCQgAQlIQGqDjF+21ELyvDX5FqISkp8HoCRqEu4KSEACcsQgvwUYAHt3cFOqYEgzAAAAAElFTkSuQmCC',\r\n            // 25 silver wand\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAARhJREFUeNrs2ksKgzAUheEkZC0O3YJzXYvLU3ArCk5dRuoNVUpJQaMDz+25IKQOCh8/Plq1IQSjfZz5gyGSSCKJJJJIIokkkkgiiSSSSCKJJJJIIokkkkgiiSSSyOeP14BomiY+ZO373qaet3oNwLZtt4/BrvMN9ejAdYvreZ7Ney1Cq6rkNE3J9edY9HcGpGZRFHE9jqPpus5Cnl3Xwyy5CbCqqh0oJx7Zr+4SUpblDlR3nazrOlYchmHf9+vQc9oqpqBOS0WVt3VHjkVYpFSUO5yjFaFLHq0Ih8ypCFvyTEUoZG5FyJJnK8Igr1SEK5lTEQK5/dLIrQhVMrfi45FbxWVZLn2P017x0ci7Ksp4lIpX/ot6CTAAIumXDiDKUh4AAAAASUVORK5CYII=',\r\n            // 26 soulcutter\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAfpJREFUeNrsmb9Sg0AQhw8mjY+RgtbCjIUzNLGT98BOnYnvYWNnHsIudrGxjS9AkcewRH53HLMqfy4TkFuyOwNkmJDJx7e7dxxBnudq6hGqEwiBFEiBFEiBFEiBFEiBFEiBFEiBFEiBPGXIYHmT/lnkeX9bB1Na+5lhN48ufp1O8+vkdjKwGnKffarH5ZWKzy/1yedsUZzbadigCO6gAXaAKMzlMDqPFuouOitAv/QXtpt1eXwJWJssZJXAZX1GsQbVkaTaKm4CV9iwLhWtRQRgn5K4gEx17VpYdkOIBYUl1Kepx58BWKQyYAFa2ueTrhSU2rS1aVOXpjAu4dKUZnVjJK1NWF1lqmpIFnavhx3TfZt+3JcbELb9sdXmQ9ejGWZ2Va3iCGjUaN1kgsW0ztamDfu5rlYnMXeFtdeH+wqU1igXm42QtNPSIYWjTaenEDMZSNnabIVEp6W1ydVmKyTttJxtdqbrFGwetDKAJxIKzcVmJ2TbrIWLTSeT1p6Z8il2Np3T1QJytOkEWZeynGz2siTpu82jILts+rKK0Nviss82j4bkYNMZEs2naWuyCVDE2OtBvaQrfcimNg2o6bQAtRvbmuyySeO/QXuDdLHJvrseapMtZFOnHdvmYC9hfbLZO6SPNgd9ne6LzUEgfbM5qMk6c2PY/BZgACwVbLFh8QNzAAAAAElFTkSuQmCC',\r\n            // 27 dusty scmitar\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAZtJREFUeNrsmU2uREAQx7snlk4hYekK9tzX3hUsSWwdo19KtNDqaW80qvtVJRM9E8HPv6rrY6RSSoRuH/EPjCEZkiEZkiEZkiEZkiEZkiEZkiEZkiEZkiH9twj7saoq6wivrmvpy6Rv86AariiK6Xue55uT27Zd1k3TLLBHN6DwInZKZlkmxnGc1nEcT8ckSXbQsJ6h1RlYMkpKKUVZlgpATUvTdIHF1AVlMVCSSs4PugPt+36j6lrRNRNFRSPzrYOafwU1YMmBRke7ZyigX+VJAB2Gwe88eRbUEqNk1PzYEn7XdVbQYJXUBm57pCZkJu9rVx/UdFKgY5uQVhNSkvfuqtXEUspcAytpkD5dBTlrtSinlNOQsMvqz1kzuxjS7gpgRs5DKyHMZb1R8kpSh7iEzoY0JAb4W5FANS6dzniwnEkhLr+G9EnNR6Z1b8flJUhMTYpl3i1Kmi77dlw+Nlx+02VvgaTmspchbY110LsrpbiM7rowVsuuW68n2y0nSlJ3Wf5/MpS4dBaT2MT9KC7Fg1M8dtdQ7EeAAQB0N9nOgpmylgAAAABJRU5ErkJggg==',\r\n            // 28 weathered greataxe\r\n            'iVBORw0KGgoAAAANSUhEUgAAADkAAAA5CAYAAACMGIOFAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAn9JREFUeNrsmrFOwzAQhp1QRBECAd2AoUXKBh0ZmOAFeIGWF2Fm4wV4gFaClYURJkaGLgxIwIDYQAgEAiEI/U1TJSZx7CaidyWWrERJOnz67uyzXcf3fTHqzRX/oBWQBWQBWUAWkAVkAfnPIUu6l81mU9Z87Xbb4Vz+pZqs1+ui0Wj4ATDHlmoIcABFb7Va8ln36oxMuAah2r34PeBIGHOBNcq1wGY4hHuQLMwaDygqKCfYUpYfdzodoYYxRdDc5kkAA5biKJwZEiEbGKUK6uYFSNmom2XQUQFZVTybyzM+uo1B9R0lm6U4wNWVyf794vqWUOfINEDVOimTgKrOTghvoSw77rMAUrHpqoBoD5ef8jq95LI2mJiTYTDYvDjYi0z8poDh7x3HoZWTz7dfojL3Y3PeG4tA2wCGByAU+F3Qoa1J+wSn18/OzeO7vL+f+oi1aQtIegqBTTU34wYgDoARSISSzubhzjZLQO0qBDa9tbFIbg4K2PseCekMPVxVm5d3b79s2gJSmFq0tStswmLcvEk9RFMhk2yiBbnJBdBoFRK2iZAdmVWIziZCFja5ABqvJ5Ns2u4FkYTU2YyrglibTLJ5vL9rZAnf9DapaRUDYZsbNSGXYbBZEeN9m1UxIW7OjtRJn0/Fk1YFeV5ZnN++yuchSz5FUKNw1eUmDG/UpvtHfBRHXestSduRdtj5aAXJ2eZAm8umNgOLKPyHeVJtBWlqk0qYZjJpYpMKoNxIU8PIZGcNxmAOBisv4xIWZgEO0zAeXqOyNZlHTUsa0iY3WeckJ5sDQ3KymctxOnWbvyBtJm4uNnP7YwRlm4mQgdG0fnL1pLWpO7H+q/YtwADFMTLO/0vp8QAAAABJRU5ErkJggg=='\r\n            // END WEAPONS\r\n        ];\r\n        return string(abi.encodePacked(\r\n            (lgAssetId < 5 ? '%253Cg%253E%253Cpath d=\\'M23,48h3v1h3v1h2v1h1v1h1v1h1v3h-1v1h-17v-4h1v-1h1v-1h2v-1h2v-1h1z\\' fill=\\'var(--dms)\\'/%253E%253Cpath d=\\'M25,49h1v1h-1v1h-1v1h-1v1h-1v-1h1v-1h1v-1h1zM28,50h1v1h-1v1h-1v1h-2v1h-1v-1h1v-1h2v-1h1zM30,51h1v2h-1v1h-2v1h-1v-1h1v-1h2zM18,52h2v1h-1v2h-1v1h-1v-1h1v-1h-1v-1h1zM31,55h1v1h-1z\\' fill=\\'var(--dmb35)\\'/%253E%253Cpath d=\\'M23,48h3v1h3v1h2v1h1v1h1v1h1v3h-1v1h-4v-1h1v-1h2v-1h-1v-2h-3v-1h-2v-1h-1v1h-1v-1h-2v1h-1v1h-2v1h1v1h1v1h2v1h4v1h-11v-4h1v1h1v1h1v-1h-1v-1h-1v-1h1v-1h2v-1h2v-1h1z\\' fill=\\'var(--dmb15)\\'/%253E%253Cpath d=\\'M23,48h3v1h3v1h2v1h1v1h1v1h1v3h-1v1h-2v-1h2v-3h-1v-1h-1v-1h-2v-1h-3v-1h-3v1h-1v1h-2v1h-2v1h-1v4h-1v-4h1v-1h1v-1h2v-1h2v-1h1z\\' fill=\\'var(--dmb5)\\'/%253E%253Cimage href=\\'data:image/png;base64,' : '%253Cg%253E%253Cimage href=\\'data:image/png;base64,'),\r\n            WEAPONS[lgAssetId],\r\n            '\\'/%253E%253C/g%253E'\r\n        ));\r\n    }\r\n}\r\n"
    }
  }
}}