TestUtils = undefined
shallowRenderer = undefined

describe 'EmPagination', ->
  beforeEach ->
    TestUtils = React.addons.TestUtils
    shallowRenderer = TestUtils.createRenderer()

  it "should be disabled with no items", ->
    element = React.createElement EmPagination,
      totalItems: 0
      itemsPerPage: 0
      currentPage: 1

    shallowRenderer.render(element)
    children = shallowRenderer.getRenderOutput().props.children

    expect(children.length).toEqual(5)
    expect(children[0].props.className).toMatch('disabled')
    expect(children[1].props.className).toMatch('disabled')
    expect(children[3].props.className).toMatch('disabled')
    expect(children[4].props.className).toMatch('disabled')

  it "should have 2 steps with more items than page allows", ->
    element = React.createElement EmPagination,
      totalItems: 15
      itemsPerPage: 10
      currentPage: 1

    shallowRenderer.render(element)
    children = shallowRenderer.getRenderOutput().props.children

    expect(children.length).toEqual(6)
    expect(children[0].props.className).toMatch('disabled')
    expect(children[1].props.className).toMatch('disabled')
    expect(children[2].props.className).toMatch('active')
    expect(children[3].props.className).toMatch(' ')
    expect(children[4].props.className).toEqual(' ')
    expect(children[5].props.className).toEqual(' ')

  it "should have many steps with way more items than page allows", ->
    currentPage = 3
    element = React.createElement EmPagination,
      totalItems: 30
      itemsPerPage: 7
      currentPage: currentPage

    shallowRenderer.render(element)
    children = shallowRenderer.getRenderOutput().props.children

    expect(children.length).toEqual(9)
    expect(children[0].props.className).toEqual(' ')
    expect(children[1].props.className).toEqual(' ')
    expect(children[currentPage + 2 - 1].props.className).toMatch('active')
    expect(children[7].props.className).toEqual(' ')
    expect(children[8].props.className).toEqual(' ')
