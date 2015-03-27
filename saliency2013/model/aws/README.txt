%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%             ADAPTATIVE WHITENING SALIENCY (AWS) MODEL               %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% This function computes a saliency map from an image. 
%
%   
% Usage:
%     im = imread('image.jpg');
%     SaliencyMap = aws(im, 0.5);
%     imshow(SaliencyMap,[])
% or:
%     SaliencyMap = aws('image.jpg', 0.5);
%     imshow(SaliencyMap,[])
%
%
% Input:
%    1- An RGB image
%    2- Rescaling factor
%   
%
% Returned values:
%    SaliencyMap         - Saliency map of the input image.
%  
% Project web-page:
% http://www-gva.dec.usc.es/persoal/xose.vidal/research/aws/AWSmodel.html
%
% References:
%
% 1.-Garcia-Diaz, A.; Leborán, V.; Fdez-Vidal, X. R. and Pardo, X. M.. On the relationship between optical variability, visual saliency, and eye fixations: A computational approach. In Journal of Vision, 12 (6), 2012. 
% 2.-Garcia-Diaz, A.; Fdez-Vidal, X. R; Pardo, X. M and Dosil, R.. Saliency from hierarchical adaptation through decorrelation and variance normalization. In Image and Vision Computing, 30 (1): 51-64, 2012.
% 3.-Garcia-Diaz, A.; Fdez-Vidal, X. R; Pardo, X. M and Dosil, R.. Local Energy Variability as a Generic Measure of Bottom-Up Salience. In Pattern Recognition Techniques, Technology and Applications, pages 1-24, I-Tech Education and Publishing, Vienna, Austria, 2008. 
% 4.-Garcia-Diaz, A.; Fdez-Vidal, X. R; Pardo, X. M and Dosil, R.. Saliency Based on Decorrelation and Distinctiveness of Local Responses. In Computer Analysis of Images and Patterns, pages 261-268, Springer Berlin/Heidelberg, Lecture Notes in Computer Science 5702, 2009. 
% 5.-Garcia-Diaz, A.; Fdez-Vidal, X.; Pardo, X. and Dosil, R.. Decorrelation and Distinctiveness Provide with Human-Like Saliency. In Advanced Concepts for Intelligent Vision Systems, pages 343-354, Springer Berlin/Heidelberg, Lecture Notes in Computer Science 5807, 2009. 
% 6.-Garcia-Diaz, A.; Fdez-Vidal, X. R; Dosil, R. and Pardo, X. M. A novel model of bottom-up visual attention using local energy. In Computational Vision and Medical Image Processing. Ed Taylor & Francis (VIPimage’07), pages 255-260, 2007.
% 7.-Garcia-Diaz, A.; Fdez-Vidal, X. R; Dosil, R. and Pardo, X. M. Local energy saliency for bottom up visual attention. In Proc. IASTED International Conference on Visualization, Imaging and Image Processing (VIIP’07)., pages 154-159, 2007.
% 8.-Garcia-Diaz, A.. Modeling early visual coding and saliency through adaptive whitening: plausibility, assessment and applications. Ph.D. Thesis, Higher Technical Engineering School, University of Santiago de Compostela, 2011.


%
% Copyright (c), (Last update) 2012, Antón Garcia-Diaz et al.
% Computer Vision Group (http://www-gva.dec.usc.es/)
% Faculty of Physics
% The University of Santiago de Compostela
%
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
