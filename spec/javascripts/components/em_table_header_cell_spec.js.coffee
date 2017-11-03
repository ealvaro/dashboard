TestUtils = undefined
shallowRenderer = undefined

describe 'EmTableHeaderCell', ->
  beforeEach ->
    TestUtils = React.addons.TestUtils
    shallowRenderer = TestUtils.createRenderer()

  it "should render a th by default", ->
    element = React.createElement EmTableHeaderCell, null, 'foob'

    shallowRenderer.render(element)
    rendered = shallowRenderer.getRenderOutput()

    expect(rendered.type).toEqual('th')
    expect(rendered.props.children).toEqual('foob')

  it "should be clickable if ordered", ->
    element = React.createElement EmTableHeaderCell, isOrdered: true, 'foob'

    shallowRenderer.render(element)
    rendered = shallowRenderer.getRenderOutput()

    expect(rendered.props.children.type).toEqual('a')

  it "should be include triangle icon if ordered and active", ->
    element = React.createElement EmTableHeaderCell,
      isActive: true, isOrdered: true, 'foob'

    shallowRenderer.render(element)
    children = shallowRenderer.getRenderOutput().props.children

    expect(children.props.children.length).toEqual(2)
    expect(children.props.children[1].props.className).toMatch('triangle')
