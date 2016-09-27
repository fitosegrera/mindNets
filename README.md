# mindNets

**EMAIL:** fito@chronusartcenter.org

**WEBSITE:** http://fii.to

This module is an exploration on wearable and wireless brain-computer interfaces and their potential for artistic experimentation and deeper inquiry on the possibility of expanding and sharing brain data by technological means. The students will get hands on some of these EEGs and will learn how to connect to them and extract their data while considering important questions regarding the meaning of such data. Eventually we will program simple Android Applications to interact with the brain-sensor and other features from the phone, including the camera. The main objective is to think about the possibility of a technologically-augmented and networked mind, while prototyping systems that resolve in artistic expressions.

## Session 1

###**Description:** 

Introduction to the the idea of augmented networked minds; this session will begin with a one and a half hour long presentation and short discussion about some theories and concepts behind the main focus of the module. Some related projects will be presented, from both artistic and non-artistic fields. Finished the presentation, the class will continue with a demonstration of a portable electroencephalogram and how it can be wireless interfaced with a computer. We will use processing to write a simple android application which can read and extract the data from the EEG.

###**Homework::MEMORY** (due next session): 

1. In groups, the students will think about the relevance of human memory and how technology can mediate and/or augment this. You need to put together your project's ideas onto a presentation. Each group will have 15 minutes MAXIMUM to presnt their proposal during the first hour of our next session. Considerations for a proper presentation:

- Conceptual Framework: what are you trying to explore with your project? What aspect of memory you are interested in? How will you use an EEG (considering it's strengths and limitations) in order to express your ideas?

- Sketches, technical diagrams, system diagrams: all your images should be used to ilustrate your project.

- What are the artistic considerations of your project? What is your Brain-Computer system going to produce?

- Aesthetic Choices: you need to justify the artistic outcomes you choose; for example: why video or photo? why a phone app? why gree color and not red? why 3D digital objects and not just sound? etc...

Remember how I presented my project AGNOSIS: The Lost Memories during our first session.

2. All students MUST install android for processing following the instrucctions given on this link (TURN ON YOUR VPNs otherwise it won't work): http://android.processing.org. Once installed you should follow the getting_started tutorial here: http://android.processing.org/tutorials/getting_started/index.html

Once you finished installing android for processing and tested it with the getting_started tutorial, you should try the code called "phoneAppBCI" located in this repository inside the folder "session_1":
	
		session_1/phoneAppBCI

This is a processing sketch, to run it follow this instructions:

1. Open processing and make sure it is on ANDROID MODE.
2. Connecto your android phone to your computer (make sure USB debug mode is enabled as shown in the getting_started tutorial)
3. On processing menu -> android -> select device make sure you choose your phone.
4. RUN the sketch.

It should take a minute or two but if there are no errors you should see a new app installed in your android phone called "phoneAppBCI"

To use the APP:

1. Turn on the neurosky and enable pairing mode, follow this link if you don't know how to do it: [INSTRUCTIONS FOR PARING MODE](https://www.google.de/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&ved=0ahUKEwiqip3t_q7PAhWCXRQKHVceDrQQFgglMAE&url=http%3A%2F%2Fdownload.neurosky.com%2Fsupport_page_files%2FMindWaveMobile%2Fdocs%2Fmindwave_mobile_user_guide.pdf&usg=AFQjCNHprDXL63yYJ507PPvW5guwdZi76A&bvm=bv.133700528,bs.1,d.d24&cad=rja)
2. Open your bluetooth setting on your phone, search for the mindwave mobile and pair it.
3. Once paired, weare the mindwave mobile and run the "phoneAppBCI" APP on your phone.
4. Play with the app for a while and we will discuss about the experience on our next session.

