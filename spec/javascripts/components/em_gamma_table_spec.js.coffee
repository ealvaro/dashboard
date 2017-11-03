TestUtils = undefined
shallowRenderer = undefined

describe 'EmGammaTable', ->
  beforeEach ->
    TestUtils = React.addons.TestUtils
    shallowRenderer = TestUtils.createRenderer()

  it "should render the table", ->
    element = React.createElement EmGammaTable,
      gammas: []
      height: 300
    shallowRenderer.render element

    rendered = shallowRenderer.getRenderOutput()

    expect(rendered.type).toBe('div')
    expect(rendered.props.children.length).toEqual(2)

  it "should render the header", ->
    element = React.createElement EmGammaTable,
      gammas: []
      height: 300
    shallowRenderer.render element

    ul = shallowRenderer.getRenderOutput().props.children[0]
    expect(ul.type).toBe('ul')
    expect(ul.props.children.type).toBe('li')

    md = ul.props.children.props.children[0]
    expect(md.type).toBe('span')
    expect(md.props.children).toBe('Measured Depth')

    counts = ul.props.children.props.children[1]
    expect(counts.type).toBe('span')
    expect(counts.props.children).toBe('Counts')

  it "should render empty rows with no gammas", ->
    element = React.createElement EmGammaTable,
      gammas: []
      height: 300
    shallowRenderer.render element

    div = shallowRenderer.getRenderOutput().props.children[1]
    ul = div.props.children
    expect(ul.props.children.length).toEqual(0)

  it "should render one row with one gamma", ->
    element = React.createElement EmGammaTable,
      gammas: [{measured_depth: 42, count: 67}]
      height: 300
    shallowRenderer.render element

    div = shallowRenderer.getRenderOutput()
    ul = div.props.children[1].props.children
    expect(ul.props.children.length).toEqual(1)

    li = ul.props.children[0]
    expect(li.props.children[0].props.children).toEqual(42)
    expect(li.props.children[1].props.children).toEqual(67)

  it "should render many rows with many gammas", ->
    element = React.createElement EmGammaTable,
      gammas:
        [
          {measured_depth: 0, count: 0}
          {measured_depth: 1, count: 1}
          {measured_depth: 2, count: 2}
          {measured_depth: 3, count: 3}
          {measured_depth: 4, count: 4}
        ]
      height: 300
    shallowRenderer.render element

    div = shallowRenderer.getRenderOutput()
    ul = div.props.children[1].props.children
    expect(ul.props.children.length).toEqual(5)
