function result = select(strct,anzahl)

names = fieldnames(strct);
result = zeros(length(strct.(names{1})),length(anzahl));
for i=1:length(anzahl)
    result(:,i) = strct.(names{anzahl(i)});
end