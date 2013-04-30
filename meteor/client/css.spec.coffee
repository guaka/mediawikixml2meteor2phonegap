

if wereTesting()
  describe "All CSS", ->
    elementIds = _.filter (_.map $('*'), (el) -> el.attributes['id']), (id) -> id?
    elementIds = _.map elementIds, (el) -> el.nodeValue

    it 'should have unique ids', ->
      expect(_.uniq(elementIds).length).toBe(elementIds.length)

    # for el, count of _.countBy(elementIds, (el) -> el)
    #  it '#' + el + ' should only occur once', ->
    #    expect(count).toBe(1)
