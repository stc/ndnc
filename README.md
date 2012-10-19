Web-based sound visualisation for "No Distance. No contact" 

Concept

"No Distance. No Contact" is originally a project that investigates people’s interactions in a given public space and present the changes of non-perceptible energy fields between them via sound-experiences. This interactive application is making possible to literally feel and try the diffusing fields and the filtered qualities of the sonic landscape that was originally available on the actual installation space. This piece of software is part of the ongoing DLA postgradual studies of Agoston at the Moholy-Nagy University of Design & Arts.

The code is made with cutting edge open web technologies using javascript ( Web Audio, ProcessingJS, iQuery ), html5, css3 technologies.
All material is published under GPL 3 unless otherwise stated
(c) Agoston Nagy 2012
stc@binaura.net




Software changelog

    v2.0
    	+ complete rewrite
    	+ moved to Github

	v1.85 changes:
		+ Cleaned up color Scheme with the Gui
		+ Separated info / playground using jQuery animations

	v1.8 changes:
		+ Added control sliders to play with the Verlet Physics engine (using dat.gui)
	    + Fixed sound preloading
	    		
	v1.7 changes:
		+ Added spectral sound vizualization
		+ Resized interface dimensions to have more meaningful space on the site
		+ Added the option to select the sounds of both London & Helsinki
		
	v1.6 changes:
		+ Textual sound labeling (more accurate visual feedback)
		
		
	v1.5 changes:	
		+ Added sounds (using Web Audio API's audiocontext)
		+ filtering, sound handling based on input data	
		+ improved visual feedback on node selection / visualization
		+ separate functions for different simulation strategies (collected data, random movements, mouse interactions)
		
	v1.1 changes:
		+ Removed random particle movements 
		+ Added DataReader Class for reading logged data (access points of data can be changed via key commands) 
		+ Added VerletDisplay Class to visualize data (based on toxiclibs 2D physical system) 
		+ Added mouse interaction 
	
	v1.0:
		The system is based on the logged data from each device. The movement (and distance) 
		will be stored continuously to a database. This set can be observed later: the sounds and visuals will be based on
		the measured distances. Each participant is represented with a circle, they are connected with lines indicating 
		their distance. It is in very early stage (no database, no sounds yet, only random movem	