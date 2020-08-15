% dependency: export_fig from mathworks exchange

%% spurious clusters
clc, clear
print_fig=0;
n=100;

%%
for jj=1
    x=2*rand(n,1);
    x=sort(x);
    [foo,bar]=hist(x,20);
    foo=foo/sum(foo)*100;
        
    %
    [f,xi]=ksdensity(x);
    f=f/max(f);
    
    %
    X=x(x>0.5);
    X=X(X<1.5);
    
    k = 1:10;
    nK = numel(k);
    options = statset('MaxIter',10000);
    gm = cell(nK,1);
    bic = zeros(nK,1);
    converged = false(nK,1);    
    
    % Fit all models
    for m = 1:nK
        gm{m} = fitgmdist(X,k(m),...
            'CovarianceType','full',...
            'SharedCovariance',false,...
            'Options',options);
        bic(m) = gm{m}.BIC;
        converged(m) = gm{m}.Converged;
    end
        
    %
    [~,minbic]=min(bic)
    gmBest=gm{minbic};
    
    t=linspace(-2,2,1000);
    for j=1:minbic
        y{j}=normpdf(t,gmBest.mu(j),sqrt(gmBest.Sigma(j))); %*gmBest.ComponentProportion(j);
        maxy(j)=max(y{j});
    end
    
    
    %
    figure(1), clf, hold all
    gr=0.75*[1 1 1];
    stem(x,1*ones(n,1),'w','marker','none','linewidth',0.1)
    set(gcf,'Color','None')
    set(gca,'color','none')
    xlim([0.5,1.5])
    ylim([0,1.2])
    set(gca,'XTick',[],'YTick',[])
    tit=['$n=$', num2str(n/2)];
    title(tit,'interp','latex','color','w','fontsize',24)
    if print_fig, export_fig('images/spikes.png'); end
    
    plot(xi,f,'color',gr,'linewidth',2)
    if print_fig, export_fig('images/spikes_kde.png'); end
    
    for j=1:minbic
        fill(t,y{j}/max(maxy),gr,'EdgeColor',gr)
    end
    tit=[tit, ', $\hat{k}=$', num2str(minbic)];
    title(tit,'interp','latex','color','w','fontsize',24)
    if print_fig, export_fig(['../images/spikes_bic', num2str(jj),'.png']); end
    
end


%% overlapping clusters

mu(1)=-1;
mu(2)=1;
Sigma(1)=1;
Sigma(2)=1;
lent=1000;
t=linspace(-5,5,lent);

figure(2), clf, hold all
for j=1:2
    y{j}=normpdf(t,mu(j),sqrt(Sigma(j))); %*gmBest.ComponentProportion(j);
    fill(t,y{j},gr,'EdgeColor',gr)
end
negs=((y{2}-y{1})>0);
cp=min(find(negs>0));
fill(t,[y{2}(1:cp),y{1}(cp+1:end)],'w','EdgeColor','w')
ht=-0.02;
text(mu(1)-0.1,ht,'$\mu_1$','interp','latex','fontsize',18,'color',gr)
text(mu(2)-0.1,ht,'$\mu_2$','interp','latex','fontsize',18,'color',gr)
stem(mu(1),ht+0.06,'k','marker','none')
stem(mu(2),ht+0.06,'k','marker','none')
set(gcf,'Color','None')
set(gca,'color','none')
xlim([-4,4])
ylim([0,0.4])
set(gca,'XTick',[],'YTick',[])
if print_fig, export_fig(['../images/overlap.png']); end

%% levels

ls=7;
n=2^ls;
a=zeros(ls,n);

% a(1,:)=1;
% a(1,n/2)=0;
% imagesc(a)
% colormap('gray')
% % imwrite(a,'levels.png')
% set(gcf,'Color','None')
% set(gca,'color','none')
% set(gca,'XTick',[],'YTick',[])
% if print_fig, export_fig(['images/levels.png']); end

for i=1:ls
    a(i,:)=1;
    a(i,round(1/2^i*[1:2^i-1]*n))=0;
    if i==ls, a(i,:)=0; end
    imagesc(a)
    set(gcf,'Color','None')
    set(gca,'color','none')
    set(gca,'XTick',[],'YTick',[])
    if print_fig, export_fig(['../images/levels', num2str(i-1), '.png']); end
end

%% effect size

z=[0.011595501
0.011595501
0.023624073
0.023624073
0.054524625
0.054524625
0.082409656
0.082409656
0.102259812
0.102259812
0.119694566
0.119694566
0.135075342
0.135075342
0.148278205
0.148278205
0.170932787
0.170932787
0.178807866
0.178807866
0.188141869
0.188141869
0.229733195
0.229733195
0.283034872
0.283034872
0.289742183
0.289742183
0.353817834
0.353817834
0.465417825
0.465417825
0.597990049
0.597990049
0.759892601
0.759892601
0.764816385
0.764816385
0.866950281
0.866950281
0.885920316
0.885920316];

z=unique(z);

z=[z; 0.0163];

lw=2;
figure(3), clf, hold all
gr=0.75*[1 1 1];
stem(z,1*ones(length(z),1),'k','marker','none','linewidth',lw)
axis('tight')
set(gca,'XTick',[],'YTick',[])
% xlabel('difference between groups')
% set(gcf,'Color','None')
% set(gca,'color','none')
% tit=['$n=', num2str(n/2), ', \hat{k}=$', num2str(minbic)];
% title(tit,'interp','latex','color','k','fontsize',24)
if print_fig, export_fig('../images/inverse_batch.png','-r300'); end

stem(z(end),1,'r','marker','none','linewidth',lw)
if print_fig, export_fig('../images/inverse_batch_sex.png','-r300'); end

%% cci

X=[111.08 83.49 115.68 94.22 88.09 114.15 106.49 76.34 101.89 83.49 103.42 98.82 111.08 98.82 104.95 97.29 106.49 88.09 109.55 92.69 101.38 100.35 95.75 86.56 91.16 108.02 101.89 89.62 117.22 112.11 108.02 111.08 94.22 98.82 117.22 95.75 104.95 100.35 77.36 95.75 95.75 100.35 109.04 94.22 97.29 101.89 95.75 88.09 101.89 112.11 98.82 95.75 101.89 91.16 98.82 95.75 98.82 104.95 101.89 100.35 92.69 74.29 98.82 95.75 94.22 109.55 101.89 104.95 98.82 94.22 100.35 103.42 108.02 107.51 121.82 NaN 100.35 94.22 115.68 124.37 92.69 100.35 85.02 85.02 112.62 106.49 103.42 94.22 123.86 89.62 80.42 101.89 NaN 75.31 102.4 112.62 98.82 114.15 101.89 112.62 95.75 NaN 97.8 109.55 NaN NaN 106.49 98.82 95.75 108.02 118.75 100.35 85.02 108.02];
X=X';
% X=X/max(X);

figure(4), clf
stem(X)

k = 1:10;
nK = numel(k);
options = statset('MaxIter',10000);
gm = cell(nK,1);
bic = zeros(nK,1);
converged = false(nK,1);

% Fit all models
for m = 1:nK
    gm{m} = fitgmdist(X,k(m),...
        'CovarianceType','full',...
        'SharedCovariance',false,...
        'Options',options);
    bic(m) = gm{m}.BIC;
    converged(m) = gm{m}.Converged;
end

%
[~,minbic]=min(bic)
gmBest=gm{minbic};

t=linspace(-2,2,1000);
for j=1:minbic
    y{j}=normpdf(t,gmBest.mu(j),sqrt(gmBest.Sigma(j))); %*gmBest.ComponentProportion(j);
    maxy(j)=max(y{j});
end

%% # edges


A = fscanf('code/humans/KKI2009_113_2_bg.edgelist','%d%c%d');
fprintf(fileID,'%4.4f\n',x);
fclose(fileID);


%% changing lambda

z=rand(10000,1)>0.999;
z=[z; rand(10000,1)>0.98];
z=[z; rand(10000,1)>0.999];
z=[z; rand(10000,1)>0.98];


l=length(z)/4;

y=[ones(l,1); 2*ones(l,1); ones(l,1); 2*ones(l,1)]/4;
y=y-0.75;

lw=2;
figure(4), clf, hold all
gr=0.75*[1 1 1];
% stem(z,1*ones(length(z),1),'w','marker','none','linewidth',lw)
plot(z,'w'),
plot(y,'w')
axis('tight')
set(gca,'XTick',[],'YTick',[])
set(gcf,'Color','None')
set(gca,'color','none')
if print_fig, export_fig('../images/lambda2.png'); end

%%

ERii=triu(rand(50,50)>0.9);
ERii=ERii+ERii';
ERii(ERii>1)=0;

ERij=rand(50,50)>0.99;

A1=[ERii, ERij];
A2=[ERij, ERii];
A=[A1;A2];

colormap('gray')
imagesc(A)
set(gca,'xtick','','ytick','')
if print_fig, export_fig('../images/sbm.png'); end

%% latent position model

n=50;
eps=0.2;
x0=randn(25,2)*eps+[1,0];
x1=randn(25,2)*eps+[0,1];

x=[x0;x1];

P=x*x';

P=P-min(P(:));
P=P./max(P(:));

imagesc(P), colormap(gray), colorbar
axis('square')
set(gca,'xtick','','ytick','')
if print_fig, export_fig('../images/P_lpm.png'); end

A=rand(n,n)>P;

imagesc(A), 
axis('square')
set(gca,'xtick','','ytick','')
if print_fig, export_fig('../images/A_lpm.png'); end


plot(x(:,1),x(:,2),'.')
axis('square')
set(gca,'xtick','','ytick','')
if print_fig, export_fig('../images/X_lpm.png'); end


%%
clear, clc, clf

print_fig=1;
n=100;
x=rand(n,1);

%
X=x(x>0.5);
X=X(X<1.5);

stem(x,1*ones(n,1),'k','marker','none','linewidth',0.1)
% set(gcf,'Color','None')
% set(gca,'color','none')
xlim([0.5,1.0])
ylim([0,1.2])
set(gca,'XTick',[],'YTick',[])

int=round(rand*9+1)+10
if print_fig, 
    export_fig(['../images/bitstring', num2str(int),'.png']); 
end

