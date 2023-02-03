# COMMANDS USED TO PERFORM REPEAT ANALYSIS 

### Build database
```
dfam-tetools.sh --singularity -- BuildDatabase -name bova -engine ncbi Bova1.4.fa 
```

### De novo repeat discovery
```
dfam-tetools.sh --singularity -- RepeatModeler --engine ncbi -threads 20 -database bova
``` 

### Screen sequence for interspersed repeats
```
dfam-tetools.sh --singularity -- RepeatMasker --gff -pa 20 -lib bova.consensi.fa.classified Bova1.4.fa
```

These same commands were performed for the _Mnemiopsis leidyi_, _Pleurobrachia bachei_, and _Hormiphora californensis_ assemblies for purposes of comparison.
