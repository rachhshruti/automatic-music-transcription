# Automatic Transcription of Piano Music
The goal of this project is to automate the music transcription process from a musical recording. In this project, we will consider piano recordings consisting of only monophonic notes i.e. only a single note will be played at a time. There are many algorithms to generate musical sheets from an audio such as autocorrelation, CQT transform and cepstral based. This project will focus on YIN, which is a modified autocorrelation algorithm, and cepstral algorithm. [Read More](https://github.com/rachhshruti/automatic-music-transcription/blob/master/AutomaticTranscriptionOfPianoMusic.pdf)

# Running the Code
	Rscript pitch-detection.R sound-file-path

It accepts one command line argument which is the path of sound file whose notation is to be identified.

# Results:
1. DG
	
	Actual notes:
	
		D G
	
	Cepstrum method:
	
		D G
	
	Accuracy: 100%

2. D chord
	Actual notes:
		
		D F# A D
	Cepstrum method:
		
		D F# A D#
	Accuracy: 75%

	
3. Ode to Joy
	
	Actual notes:
		
		E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 E4 D4 
		E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 D4 C4

	Cepstrum method:
 		
		E4 E4 F4 G4 G4 F4 E4 D4 C4 C4 D4 E4 E4 D4
 		E4    F4 E4 G4 G4    E4 D4 C4 C4 D4 E4 D4 C4
	
	Accuracy: 89% (2 missing notes and one additional note is detected)

4. Mary had a little lamb
	Actual notes: 
		
		E4 D4 C4 D4 E4 E4 E4 D4 D4 D4 E4 E4 E4
	Cepstrum method:
		
		E4 D4 C4 D4 E4 E4 E4 D4 D4 D4 E4 E4 E4 E3
	Accuracy: 96% one extra low E (E3) detected  
