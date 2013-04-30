

if wereTesting()
  describe 'Parser', ->
    it 'should return empty string for empty string', ->
      expect(articleParse('', config)).toBe ''

    it 'should work for headings', ->
      expect(articleParse('== Hitchhiking ==', config)).toMatch /<h2>\s*Hitchhiking\s*<\/h2>/
      expect(articleParse('=== Hitchhiking ===', config)).toMatch /<h3>\s*Hitchhiking\s*<\/h3>/
      expect(articleParse('==== Hitchhiking ====', config)).toMatch /<h4>\s*Hitchhiking\s*<\/h4>/

    it 'should make stuff bold and italic', ->
      expect(articleParse("''Hitchhiking''", config)).toMatch /<em>Hitchhiking<\/em>/
      expect(articleParse("'''Hitchhiking'''", config)).toMatch /<strong>Hitchhiking<\/strong>/

    it 'should make external links open in new window', ->
      expect(articleParse("[http://guaka.org/]", config)).toMatch /target=\"_blank\"/

    it 'should handle lists', ->
      expect(articleParse("* aleph\n* beth\n* gimel", config)).toMatch /<ul><li>\s*aleph\s*<\/li><li>\s*beth<\/li><li>\s*gimel<\/li><\/ul>/
      expect(articleParse("# one\n# two\n# three", config)).toMatch /<ol><li>\s*one\s*<\/li><li>\s*two<\/li><li>\s*three<\/li><\/ol>/
