---
to: tslint.json
---
{
  "compilerOptions": {
    "plugins": [
      {
        "name": "typescript-tslint-plugin",
        "alwaysShowRuleFailuresAsWarnings": false,
        "ignoreDefinitionFiles": true,
        "configFile": "../tslint.json",
        "suppressWhileTypeErrorsPresent": false,
        "mockTypeScriptVersion": false,
        "no-null-keyword": true,
        "no-magic-numbers": [
          true,
          {
            "allowed-numbers": [
              1,
              2,
              3
            ],
            "ignore-jsx": true
          }
        ]
      }
    ]
  }
}