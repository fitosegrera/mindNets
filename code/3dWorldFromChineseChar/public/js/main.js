function setupCamera() {
    camera.position.z = 1000;
    camera.position.x = 240;
    camera.position.y = 0;
    camera.lookAt(new THREE.Vector3(0, 0, 0));
}

function addLights() {
    var ambientLight = new THREE.AmbientLight(0x444444);
    ambientLight.intensity = 0.0;
    scene.add(ambientLight);
    var directionalLight = new THREE.DirectionalLight(0xffffff);
    directionalLight.position.set(900, 400, 0).normalize();
    scene.add(directionalLight);
}

function getTerrainPixelData() {
    var img = document.getElementById("landscape-image");
    var canvas = document.getElementById("canvas");
    canvas.width = img.width;
    canvas.height = img.height;
    canvas.getContext('2d').drawImage(img, 0, 0, img.width, img.height);
    var data = canvas.getContext('2d').getImageData(0, 0, img.width, img.height).data;
    var normPixels = [];
    for (var i = 0; i < data.length; i+= 4) {
        normPixels.push((data[i] + data[i + 1] + data[i + 2]) / 3);
    }
    return normPixels;
}

function addGround() {
    var numSegments = 100;
    var geometry = new THREE.PlaneGeometry(2000, 2000, numSegments, numSegments);
    var material = new THREE.MeshLambertMaterial({
        color: 0xccccff,
        wireframe: false
    });
    terrain = getTerrainPixelData();
    console.log("terrain length: " + terrain.length + " / vertices: " + geometry.vertices.length);
    for (var i = 0; i < geometry.vertices.length; i++) {
        var terrainValue = terrain[i] / 255;
        geometry.vertices[i].z = geometry.vertices[i].z + terrainValue * 400;
    }
    geometry.computeFaceNormals();
    geometry.computeVertexNormals();
    var plane = new THREE.Mesh(geometry, material);
    plane.position = new THREE.Vector3(0, 0, 0);
    scene.add(plane);
}

function render() {
    requestAnimationFrame(render);
    renderer.render(scene, camera);
}

var scene = new THREE.Scene();
var renderer = new THREE.WebGLRenderer();
var camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 10000);
var controls = new THREE.OrbitControls(camera, renderer.domElement);

setupCamera();
addLights();
addGround();

renderer.setSize(window.innerWidth, window.innerHeight);
document.body.appendChild(renderer.domElement);

render();
