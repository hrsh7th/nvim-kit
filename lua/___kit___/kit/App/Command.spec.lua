local Command = require('___kit___.kit.App.Command')

describe('kit.App.Command', function()
  local command = Command.new('Misc', {
    month = {
      args = {
        ['--lang'] = {
          complete = function()
            return {
              'en',
              'ja'
            }
          end
        },
        [1] = {
          complete = function()
            return {
              'January',
              'February',
              'March',
              'April',
              'May',
              'June',
              'July',
              'August',
              'September',
              'October',
              'November',
              'December'
            }
          end
        }
      },
      execute = function()
        vim.print('Misc')
      end
    }
  })

  it('complete', function()
    assert.are.same({
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    }, command:complete('Misc month ', 11))
    assert.are.same({
      '--lang'
    }, command:complete('Misc month -', 12))
    assert.are.same({
      'en',
      'ja',
    }, command:complete('Misc month --lang=', 18))
    assert.are.same({
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    }, command:complete('Misc month --lang=ja ', 21))
  end)

  it('_parse', function()
    assert.are.same({
      { text = 'Misc',  s = 0,  e = 4 },
      { text = 'month', s = 5,  e = 10 },
      { text = 'j',     s = 11, e = 12 }
    }, command:_parse('Misc month j'))
    assert.are.same({
      { text = 'Misc',  s = 0,  e = 4 },
      { text = 'month', s = 5,  e = 10 },
      { text = '',      s = 11, e = 11 }
    }, command:_parse('Misc month '))
  end)
end)
