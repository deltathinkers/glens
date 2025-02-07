// Generated by CoffeeScript 1.4.0
/**
 * GCodePainter
 * Renders
*/

var GCodePainter;

GCodePainter = (function() {

  function GCodePainter() {
    this.index = 0;
    this.viewModels = [];
    this.baseObject = new THREE.Object3D;
    this.motionGeo = new THREE.Geometry;
    this.motionIncGeo = new THREE.Geometry;
    this.motionIncMat = new THREE.LineBasicMateria({
      opacity: 0.2,
      transparent: true,
      linewidth: 1,
      vertexColors: THREE.VertexColors
    });
    this.feedAllGeo = new THREE.Geometry;
    this.feedGeo = new THREE.Geometry;
    this.feedMat = new THREE.LineBasicMateria({
      opacity: 0.8,
      transparent: true,
      linewidth: 2,
      vertexColors: THREE.VertexColors
    });
    this.feedIncGeo = new THREE.Geometry;
    this.feedIncMat = new THREE.LineBasicMateria({
      opacity: 0.2,
      transparent: true,
      linewidth: 2,
      vertexColors: THREE.VertexColors
    });
    this.lastLine = {
      x: 0,
      y: 0,
      z: 0,
      e: 0,
      f: 0
    };
    this.relative = false;
    this.bounds = {
      min: {
        x: 100000,
        y: 100000,
        z: 100000
      },
      max: {
        x: -100000,
        y: -100000,
        z: -100000
      }
    };
  }

  return GCodePainter;

})();
