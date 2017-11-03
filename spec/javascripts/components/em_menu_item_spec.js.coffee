TestUtils = undefined
shallowRenderer = undefined

describe 'EmMenuItem', ->
  beforeEach ->
    TestUtils = React.addons.TestUtils
    shallowRenderer = TestUtils.createRenderer()

  it "should provide default menu item text", ->
    element = React.createElement EmMenuItem
    shallowRenderer.render(element)
    rendered = shallowRenderer.getRenderOutput()

    expect(rendered.props.children).toEqual('Untitled Entry')

  it "should render the menu item", ->
    element = React.createElement EmMenuItem, null, 'my menu item'
    shallowRenderer.render(element)
    rendered = shallowRenderer.getRenderOutput()

    expect(rendered.type).toBe('a')
    expect(rendered.props.children).toEqual('my menu item')
