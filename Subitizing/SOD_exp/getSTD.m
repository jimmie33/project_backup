function R_std = getSTD(R,nInst)

R_std = bsxfun(@times,R,1./max(nInst(:),1));
R_mean = sum(R)/sum(nInst);
R_std = bsxfun(@minus,R_std,R_mean);
R_std = R_std.^2;
R_std = sqrt(nInst(:)'*R_std/sum(nInst));