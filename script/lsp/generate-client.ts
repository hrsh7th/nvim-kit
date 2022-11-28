import fs from 'fs';
import dedent from 'ts-dedent';
import { toTypeNotation } from '.';
import metaModel from '../../tmp/language-server-protocol/_specifications/lsp/3.18/metaModel/metaModel.json';

(() => {
  const client = dedent`
    local LSP = require('___kit___.kit.LSP')
    local AsyncTask = require('___kit___.kit.Async.AsyncTask')

    ---@class ___kit___.kit.LSP.Client
    ---@field public client table
    local Client = {}
    Client.__index = Client

    ---Create LSP Client wrapper.
    ---@param client table
    ---@return ___kit___.kit.LSP.Client
    function Client.new(client)
      local self = setmetatable({}, Client)
      self.client = client
      return client
    end

    ${metaModel.requests.map(request => {
    const params = (() => {
      if (request.params) {
        const depends = [] as string[];
        depends.push(`---@param params ${toTypeNotation(request.params as any, depends)}`);
        return depends.join('\n');
      }
      return '---@param params nil';
    })();
    return dedent`
      ${params}
      function Client:${request.method.replace(/\//g, '_')}(params)
        local that, request_id, reject_ = self, nil, nil
        local task = AsyncTask.new(function(resolve, reject)
          request_id = self.client.request('${request.method}', params, function(err, res)
            if err then
              reject(err)
            else
              resolve(res)
            end
          end)
          reject_ = reject
        end)
        function task:cancel()
          that.client.cancel_request(request_id)
          reject_(LSP.ErrorCodes.RequestCancelled)
        end
        return task
      end
      `;
  }).join('\n\n').trim()}

    return Client
  `;;
  fs.writeFileSync(`${__dirname}/../../lua/___kit___/kit/LSP/Client.lua`, client, 'utf-8');
})();

