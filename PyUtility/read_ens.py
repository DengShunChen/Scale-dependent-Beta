#!/usr/bin/env python
from evaluate import Evaluate 
import numpy as np
import json

ev = Evaluate()
truth = ev.get_ens_data('letkfi00l05m10/output_analy_ens.txt')


