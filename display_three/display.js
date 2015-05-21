$(document).ready(function () {

	// standard global variables
	var container, scene, camera, renderer, controls, stats;
	var keyboard = new THREEx.KeyboardState();
	var clock = new THREE.Clock();

	// custom global variables
	var cube;
	var cubeGeo;
	var squareTexture;
	var squareMaterial;

	// grid
	var GRID_SIZE = 5;
	var GRID_X = 160;
	var GRID_Y = 140;

	// maskData
	var MASK_THRESHOLD = 1,
		maskData = _([]);

	function validMask(x, y) {
		return maskData.find({x: x, y: y}) != undefined;
	}

	function init() {

		var maskImage = $('img.mask').get(0),
			maskCanvas = $('canvas.mask').get(0),
			maskContext = maskCanvas.getContext('2d');
		maskContext.drawImage(maskImage, 0, 0, maskImage.width, maskImage.height);
		var pixels = maskContext.getImageData(0, 0, maskImage.width, maskImage.height);
		for (var i = 0; i < pixels.data.length; i += 4) {
			// 4 because using only RED channel to test
			var n = i / 4,
				x = n % pixels.width,
				y = Math.floor(n / pixels.width);
			if (pixels.data[i] > MASK_THRESHOLD) {
				maskData.push({
					x: x,
					y: y
				})
			}
		}
		maskCanvas.remove();
		maskImage.remove();

		// SCENE
		scene = new THREE.Scene();
		// CAMERA
		var SCREEN_WIDTH = window.innerWidth, SCREEN_HEIGHT = window.innerHeight;
		var VIEW_ANGLE = 45, ASPECT = SCREEN_WIDTH / SCREEN_HEIGHT, NEAR = 0.1, FAR = 20000;
		console.log(ASPECT);
		camera = new THREE.PerspectiveCamera(VIEW_ANGLE, ASPECT, NEAR, FAR);
		scene.add(camera);
		camera.position.set(0, 150, 400);
		camera.lookAt(scene.position);
		// RENDERER
		if (Detector.webgl)
			renderer = new THREE.WebGLRenderer({antialias: true});
		else
			renderer = new THREE.CanvasRenderer();
		renderer.setSize(SCREEN_WIDTH, SCREEN_HEIGHT);
		container = document.getElementById('ThreeJS');
		container.appendChild(renderer.domElement);
		// EVENTS
		THREEx.WindowResize(renderer, camera);
		THREEx.FullScreen.bindKey({charCode: 'm'.charCodeAt(0)});
		// CONTROLS
		controls = new THREE.OrbitControls(camera, renderer.domElement);
		// STATS
		stats = new Stats();
		stats.domElement.style.position = 'absolute';
		stats.domElement.style.bottom = '0px';
		stats.domElement.style.zIndex = 100;
		container.appendChild(stats.domElement);
		// LIGHT
		var light = new THREE.PointLight(0xffffff);
		light.position.set(0, 250, 0);
		scene.add(light);
		// FLOOR
		var floorTexture = new THREE.ImageUtils.loadTexture('checkerboard.jpg');
		floorTexture.wrapS = floorTexture.wrapT = THREE.RepeatWrapping;
		floorTexture.repeat.set(GRID_X, GRID_Y);
		var floorMaterial = new THREE.MeshBasicMaterial({map: floorTexture, side: THREE.DoubleSide});
		var floorGeometry = new THREE.PlaneGeometry(GRID_SIZE * GRID_X, GRID_SIZE * GRID_Y, 10, 10);
		var floor = new THREE.Mesh(floorGeometry, floorMaterial);
		floor.position.y = 0;
		floor.rotation.x = Math.PI / 2;
		scene.add(floor);
		// SKYBOX/FOG
		var skyBoxGeometry = new THREE.CubeGeometry(10000, 10000, 10000);
		var skyBoxMaterial = new THREE.MeshBasicMaterial({color: 0x9999ff, side: THREE.BackSide});
		var skyBox = new THREE.Mesh(skyBoxGeometry, skyBoxMaterial);
		// scene.add(skyBox);
		scene.fog = new THREE.FogExp2(0x9999ff, 0.00025);

		////////////
		// CUSTOM //
		////////////

		cubeGeo = new THREE.CubeGeometry(1, 1, 1);
		squareTexture = new THREE.ImageUtils.loadTexture("square-thick.png");
		squareMaterial = new THREE.MeshBasicMaterial({map: squareTexture, color: 0xffffff});

		for(var x=0; x<GRID_X; x++){
			for(var y=0; y<GRID_Y; y++) {
				if(validMask(x,y)) {
					var h = Math.ceil(Math.random() * 5);
					for(var z=0; z<h; z++){
						cube = new THREE.Mesh(cubeGeo);
						cube.material = squareMaterial;
						// TODO
						cube.position.x = x * GRID_SIZE - GRID_SIZE * GRID_X / 2 -GRID_SIZE/2;
						cube.position.z = y * GRID_SIZE - GRID_SIZE * GRID_Y / 2 -GRID_SIZE/2;
						cube.position.y = GRID_SIZE *z+GRID_SIZE/2;
						cube.scale = {x: GRID_SIZE, y: GRID_SIZE, z: GRID_SIZE};
						cube.name = "cube_" + x + "_" + y+ "_"+z;
						scene.add(cube);
					}

				}
			}
		}

		animate();
	}

	function animate() {
		requestAnimationFrame(animate);
		render();
		update();
	}

	function update() {
		if (keyboard.pressed("z")) {
			// do something
		}

		controls.update();
		stats.update();
	}

	function render() {
		renderer.render(scene, camera);
	}

	init();

})
