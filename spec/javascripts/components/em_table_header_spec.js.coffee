TestUtils = undefined
shallowRenderer = undefined

describe 'EmTableHeader', ->
  beforeEach ->
    TestUtils = React.addons.TestUtils
    shallowRenderer = TestUtils.createRenderer()

  it "should render a thead by default", ->
    element = React.createElement EmTableHeader, columns: []

    shallowRenderer.render(element)
    rendered = shallowRenderer.getRenderOutput()

    expect(rendered.type).toEqual('thead')
    expect(rendered.props.children.type).toEqual('tr')
    expect(rendered.props.children.props.children.length).toEqual(0)

  it "should render an Actions column", ->
    element = React.createElement EmTableHeader,
      columns: [], displayActions: true

    shallowRenderer.render(element)
    children = shallowRenderer.getRenderOutput().props.children

    expect(children.props.children.length).toEqual(1)

  it "should render columns", ->
    element = React.createElement EmTableHeader, columns: [1, 2, 3]

    shallowRenderer.render(element)
    children = shallowRenderer.getRenderOutput().props.children

    expect(children.props.children.length).toEqual(3)
