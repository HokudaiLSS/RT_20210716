function outputs = task_sort_fieldname(inputs)
%% Overview
% This is simply a way to remember how to rearrange the order of a
% structures fields alphabetically.

% Inputs
%    inputs [var]

% Outputs
%    structure [var]

%% Test Data
% inputs.Yuji = 'Yuji';
% inputs.Harunori = 'Harunori';
% inputs.Landon = 'Landon';

%% The Sort
[~, neworder] = sort(lower(fieldnames(inputs)));
inputs = orderfields(inputs, neworder);

%% Assign Symbols to Outputs
outputs = inputs;