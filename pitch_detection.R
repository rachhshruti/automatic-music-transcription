# Implementation of cepstral algorithm
cepstrum=function(x,sr){
  y=fft(x)
  c=fft(log(abs(y)), inverse = TRUE)
  ms1=sr/1000
  ms20=sr/50
  ind2=which(abs(c[ms1:ms20])==max(abs(c[ms1:ms20])))
  f0=sr/(ind2+ms1-1)
  f0
}
# Implementation of YIN algorithm
yin=function(x,sr){
  maxLag=floor(sr/27.5) #min freqency possible on 88-key keyboard is 27.5 Hz
  diffcorrelation=rep(0,maxLag)
  for(lag in 1:maxLag){
    s=0
    for(i in 1:(length(x)-lag)){
      s=s+(x[i]-x[lag+i])^2
    }
    diffcorrelation[lag]=s
  }
  #print(diffcorrelation)
  minimum=100
  minLagDiff=0
  diffcorrelation1=rep(0,maxLag)
  for(lag in 1:maxLag){
    tot=0
    for(tau in 1:lag){
      tot=tot+diffcorrelation[tau]
    }
    diffcorrelation1[lag]=diffcorrelation[lag]/((1/lag)*tot)
    if(minimum>diffcorrelation1[lag]){
      minimum=diffcorrelation1[lag]
      minLagDiff=lag
    }
  }
  f=sr/minLagDiff
  #plot((1:win),diffcorrelation1,xlab="lag",ylab="diff auto-correlation")
  f
}
convertFreqToMidi=function(f){
  #print(f)
  m=round(69+12*log2(f/440))
  m
}
library(tuneR)
args = commandArgs(trailingOnly=TRUE)
if(length(args)==0){
  stop("Too few arguments. Music file path needs to be supplied", call.=FALSE)
}

w = readWave(args[1])
y=w@left
sr=w@samp.rate
#only focusing on 3 octaves of keyboard from C3 to C6 but the pitch detection algorithms work for the entire range of 88-key keyboard.
miditonote=c("C3","C#3/Db3","D3","D#3/Eb3","E3","F3","F#3/Gb3","G3","G#3/Ab3","A3","A#3/Bb3","B3","C4","C#4/Db4","D4","D#4/Eb4","E4","F4","F#4/Gb4","G4","G#4/Ab4","A4","A#4/Bb4","B4","C5","C#5/Db5","D5","D#5/Eb5","E5","F5","F#5/Gb5","G5","G#5/Ab5","A5","A#5/Bb5","B5","C6")

N=4800
cols=floor(length(y)/N)
signal = matrix(0,cols,N)
intensity = c(rep(1,cols))
v = seq(from=0,by=2*pi/N,length=N)      # N evenly spaced pts 0 -- 2*pi
win = (1 + cos(v-pi))/2
for (t in 1:cols) {
  signal[t,]=y[(1+(t-1)*N):(t*N)]
  for(j in 1:N){
    intensity[t]=intensity[t]+signal[t,j]^2  #norm(signal[t,])  
  }
  intensity[t]=sqrt(intensity[t])
}

ratio=c(rep(0,cols))

for(i in 2:cols){
  ratio[i]=intensity[i]/intensity[i-1]
}
plot(ratio)
plot(intensity)
t = seq(from=0,by=2*pi/N,length=N)    
win = (1 + cos(t-pi))/2
midi=c()
note=c()
thresh=5
imax=1
while(ratio[imax]<thresh){
  imax=imax+1
}
imax=imax+2 
fprev=cepstrum(signal[imax,]*win,sr)

midiVal=convertFreqToMidi(fprev)
midi=c(midi,midiVal)
note=c(note,miditonote[midiVal-47])
imax=imax+1
while(imax<=cols){
    f0=cepstrum(signal[imax,]*win,sr)
    #f0=yin(signal[imax,]*win,sr) # uncomment to use YIN pitch detection algorithm. Warning: it takes a long time to compute
    if(abs(f0-fprev)<=thresh && abs(ratio[imax]-ratio[imax-1])>0.1){
      midiVal=convertFreqToMidi(f0)
      if(midiVal>47)
      {
        midi=c(midi,midiVal)
        note=c(note,miditonote[midiVal-47])  
      }
    }
    fprev=f0
    imax=imax+1  
}
plot(midi)
title("Cepstrum Results")
print("Cepstrum Output:")
print(cbind(midi,note))