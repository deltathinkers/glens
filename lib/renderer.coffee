
autoRotate = false

class Renderer

  conf =
    fov: 45
    near: 1
    far: 10000
    z: 300

  refreshSize: ->
    width = $(@container).width()
    height = $(@container).height()

    @camera.aspect = width/height
    @camera.updateProjectionMatrix()
    @renderer.setSize(width, height)
    # if @effectFXAA
    #   @effectFXAA.uniforms['resolution'].value.set(1/width, 1/height)
    @controls.handleResize()
    @composer.reset()

  onGcodeLoaded: (gcode) ->
    @gp = new GCodeParser
    @gm = @gp.parse gcode
    @gr = new GCodeRenderer
    gcodeObj = @gr.render(@gm)

    @ui.duiControllers.gcodeIndex.max(@gr.viewModels.length - 1)
    @ui.duiControllers.gcodeIndex.setValue(0)
    @ui.duiControllers.animate.setValue(true)

    @camera.position.z = 500
    @camera.position.y = -1500
    @camera.lookAt(@gr.center)

    if @object
      @scene.remove @object

    @object = gcodeObj
    @scene.add @object


  setupStats: ->
    @stats = new Stats
    @stats.domElement.style.position = 'absolute'
    @stats.domElement.style.top = '0px'
    @container.appendChild @stats.domElement

  init: () ->

    # INIT
    @scene = new THREE.Scene()
    @renderer = new THREE.WebGLRenderer {
      clearColor: 0x000000
      clearAlpha: 1
      antialias: false
    }
    @renderer.autoClear = false
    @container.appendChild(@renderer.domElement)

    # Lights...
    # [[ 0, 0, 1, 0xFFFFCC],
    #  [ 0, 1, 0, 0xFFCCFF],
    #  [ 1, 0, 0, 0xCCFFFF],
    #  [ 0, 0,-1, 0xCCCCFF],
    #  [ 0,-1, 0, 0xCCFFCC],
    #  [-1, 0, 0, 0xFFCCCC]].forEach (position) =>
    #   light = new THREE.DirectionalLight position[3]
    #   light.position.set(position[0], position[1], position[2]).normalize()
    #   @scene.add light

    # Create camera
    aspect = window.innerWidth/window.innerHeight
    console.log aspect
    @camera = new THREE.PerspectiveCamera(conf.fov, aspect, conf.near, conf.far)
    @camera.position.z = conf.z
    @scene.add(@camera)

    # Create controls
    @controls = new THREE.TrackballControls(@camera)
    @controls.dynamicDampingFactor = 0.1
    @controls.rotateSpeed = 1.0

    @composer = new THREE.EffectComposer @renderer
    @composer.addPass new THREE.RenderPass(@scene, @camera)
    # @effectFXAA = new THREE.ShaderPass THREE.ShaderExtras["fxaa"]
    # @composer.addPass @effectFXAA # Antialas?
    # @composer.addPass new THREE.BloomPass(0.4)
    effectScreen = new THREE.ShaderPass(THREE.ShaderExtras["screen"])
    effectScreen.renderToScreen = true
    @composer.addPass effectScreen

    @refreshSize()

    addEventListener 'resize', @refreshSize.bind(@)

    addEventListener 'keydown', (e) ->
      if e.keyCode is 32 # spacebar
        autoRotate = not autoRotate

    @setupStats()

  constructor: (@container, @ui) ->
    @init()
    @animate()

  animate: ->
    # requestAnimationFrame @animate.bind(@)
    setTimeout @animate.bind(@), 100
    @render()
    if @stats then @stats.update()

  render: ->
    time = Date.now() * 0.0005
    # console.log 'update?'

    for object in @scene.children
      if autoRotate and object instanceof THREE.Object3D
        object.rotation.y = object.rotation.y + 0.015

    if window.effectController and @gr
      if window.effectController.animate
        try
          @gr.setIndex @gr.index+1
          window.effectController.gcodeIndex = @gr.index
        catch e
          window.effectController.animate = false
          throw e
      else
        @gr.setIndex window.effectController.gcodeIndex

    @controls.update()
    @renderer.clear()
    @composer.render()

window.Renderer = Renderer