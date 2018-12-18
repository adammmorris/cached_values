main1 = ['fitting/2step/real1'];
main2 = ['fitting/2step_extreme/real1'];
datapath = [main1 '/data.mat'];
fitpath1 = [main1 '/fit.mat'];
fitpath2 = [main2 '/fit.mat'];

load(datapath);
subjlist = 1:length(subjMarkers);
numSubjects = length(subjlist);

modelNames_all = {'MFMB_noAS', 'MB_MB', 'MFMB_MB', 'MB_MFMB', 'MFMB_MFMB'};
modelParams = {
    [-10 -10 -10 -10, -10, 0, 0], ...
    [-10 -10 -10 -10, 1, 1, 1], ...
    [-10 -10 -10 -10, -10, 1, 1], ...
    [-10 -10 -10 -10, 1, -10, 1], ...
    [-10 -10 -10 -10, -10, -10, 1]};
whichParams_all = {1:5, 1:4, 1:5, [1:4 6], 1:6};

whichModels = 1:5;

% first
load(fitpath1);

numChoices = zeros(numSubjects, 1);
LLs_chance = zeros(numSubjects, 1);
for subj_ind = 1:length(subjlist)
    subj = subjlist(subj_ind);
    if subj < length(subjMarkers)
        index = subjMarkers(subj):(subjMarkers(subj + 1) - 1);
    else
        index = subjMarkers(subj):size(results, 1);
    end
    
    numChoices(subj) = length(index) * 2;
    LLs_chance(subj) = log(1 / 2) * length(index) * 2;
end

modelNames = modelNames_all(whichModels);
whichParams = whichParams_all(whichModels);
numModels = length(modelNames);

details = zeros(numSubjects, numModels * 2, 4);
for i = 1:numModels
    model = whichModels(i);
    details(:, i, 1) = results{model}(subjlist, 1);
    details(:, i, 2) = results{model}(subjlist, 2);
    details(:, i, 3) = results{model}(subjlist, 3);
    details(:, i, 4) = results{model}(subjlist, 4);
    
    optParams{model} = optParams{model}(subjlist,:);
end

% second
load(fitpath2)
for i = 1:numModels
    model = whichModels(i);
    details(:, 5+i, 1) = results{model}(subjlist, 1);
    details(:, 5+i, 2) = results{model}(subjlist, 2);
    details(:, 5+i, 3) = results{model}(subjlist, 3);
    details(:, 5+i, 4) = results{model}(subjlist, 4);
    
    optParams{model+5} = optParams{model}(subjlist,:);
end

compareModels_bayes(optParams(1:10), details, 1, LLs_chance);