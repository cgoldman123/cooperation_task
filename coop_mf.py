import sys, os, re, subprocess

subject_list_path = sys.argv[1]
input_directory = sys.argv[2]
results = sys.argv[3]
run = sys.argv[4]

if not os.path.exists(results):
    os.makedirs(results)
    print(f"Created results directory {results}")

if not os.path.exists(f"{results}/logs"):
    os.makedirs(f"{results}/logs")
    print(f"Created results-logs directory {results}/logs")

subjects = []
with open(subject_list_path) as infile:
    for line in infile:
        if 'ID' not in line:
            subjects.append(line.strip())

ssub_path = '/media/labs/rsmith/wellbeing/tasks/Cooperation/scripts/coop_mf.ssub'

for subject in subjects:
    stdout_name = f"{results}/logs/{subject}-%J.stdout"
    stderr_name = f"{results}/logs/{subject}-%J.stderr"

    jobname = f'coop-mf-{subject}'
    os.system(f"sbatch -J {jobname} -o {stdout_name} -e {stderr_name} {ssub_path} {subject} {input_directory} {results} {run}")

    print(f"SUBMITTED JOB [{jobname}]")


    ###python3 coop_mf.py /media/labs/rsmith/lab-members/clavalley/studies/development/wellbeing/cooperation/round3mturk/id_list_1.csv /media/labs/NPC/DataSink/StimTool_Online/WBMTURK_Cooperation_TaskCB/ /media/labs/rsmith/wellbeing/tasks/Cooperation/output/ 2