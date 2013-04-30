


if wereTesting()
  describe "Session currentTitle", ->

    it 'should change the page', ->
      runs ->
        changePage 'Paris'

      waits 100
      runs ->
        expect($('div#content').text()).toMatch /Paris is the capital of France/



