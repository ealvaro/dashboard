TestUtils = undefined
shallowRenderer = undefined

describe 'EmReceiverCog', ->
  beforeEach ->
    TestUtils = React.addons.TestUtils
    shallowRenderer = TestUtils.createRenderer()

  it "should render the cog", ->
    element = React.createElement EmReceiverCog, object: last_updates: {}
    shallowRenderer.render element
    div = shallowRenderer.getRenderOutput()

    expect(div.props.children.length).toEqual(2)
    expect(div.props.children[0].type, "button")
    expect(div.props.children[1].type, "ul")

  it "should render the Details item", ->
    element = React.createElement EmReceiverCog, object: last_updates: {}
    shallowRenderer.render element
    div = shallowRenderer.getRenderOutput()
    ul = div.props.children[1]
    li = ul.props.children[0]

    expect(li.props.children.props.children).toEqual('Details')

  it "should not render TV ID item by default", ->
    element = React.createElement EmReceiverCog, object: last_updates: {}
    shallowRenderer.render element
    div = shallowRenderer.getRenderOutput()
    ul = div.props.children[1]
    li = ul.props.children[1]

    expect(li.props.children).toEqual([])

  it "should render TV ID item when given Rx TV ID", ->
    element = React.createElement EmReceiverCog,
      object: last_updates: LeamReceiverUpdate: team_viewer_id: "12345"
    shallowRenderer.render element
    div = shallowRenderer.getRenderOutput()
    ul = div.props.children[1]
    li = ul.props.children[1]

    expect(li.props.children[0].props.children).toEqual("Copy TV ID for LEAM Receiver PC")
