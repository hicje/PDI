classdef ImageProcessingApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                      matlab.ui.Figure
        LoadImageButton               matlab.ui.control.Button
        ThresholdButton               matlab.ui.control.Button
        GrayscaleButton               matlab.ui.control.Button
        SobelButton                   matlab.ui.control.Button
        CannyButton                   matlab.ui.control.Button
        MedianFilterButton            matlab.ui.control.Button
        HighPassBasicButton           matlab.ui.control.Button
        HighPassReinforcementButton   matlab.ui.control.Button
        RobertsButton                 matlab.ui.control.Button
        PrewittButton                 matlab.ui.control.Button
        MeanFilterButton              matlab.ui.control.Button
        LoGButton                     matlab.ui.control.Button
        ZeroCrossButton               matlab.ui.control.Button
        NoiseButton                   matlab.ui.control.Button
        WatershedButton               matlab.ui.control.Button
        CountObjectsButton            matlab.ui.control.Button
        HistogramButton               matlab.ui.control.Button
        CLAHEHistogramButton          matlab.ui.control.Button 
        OriginalImageAxes             matlab.ui.control.UIAxes
        FilteredImageAxes             matlab.ui.control.UIAxes
        HistogramAxes                 matlab.ui.control.UIAxes
    end
    
    properties (Access = private)
        Image % Original image
    end

    methods (Access = private)

        % Ajusta os eixos para se adaptar ao tamanho da imagem
        function adjustAxes(app, ax)
            set(ax, 'Units', 'normalized');
            axis(ax, 'image');
            ax.XLimMode = 'auto';
            ax.YLimMode = 'auto';
        end

        % Button pushed function: LoadImageButton
        function LoadImageButtonPushed(app, event)
            [file, path] = uigetfile({'*.jpg;*.png;*.bmp;*.tif;*.jpeg', 'Image Files (*.jpg, *.png, *.bmp, *.tif, *.jpeg)'});
            
            % Verifica se o usuário selecionou um arquivo ou cancelou o diálogo
            if isequal(file, 0)
                errordlg('Nenhum arquivo selecionado.', 'Erro');
                return;
            end
            
            % Verifica se o caminho do arquivo está correto
            fullFileName = fullfile(path, file);
            if ~isfile(fullFileName)
                errordlg('Arquivo não encontrado. Verifique o caminho.', 'Erro');
                return;
            end
            
            % Tenta ler a imagem e captura erros
            try
                app.Image = imread(fullFileName);
                imshow(app.Image, 'Parent', app.OriginalImageAxes);
                imshow(app.Image, 'Parent', app.FilteredImageAxes);
                
                % Enable buttons after loading image
                app.ThresholdButton.Enable = 'on';
                app.GrayscaleButton.Enable = 'on';
                app.SobelButton.Enable = 'on';
                app.CannyButton.Enable = 'on';
                app.MedianFilterButton.Enable = 'on';
                app.HighPassBasicButton.Enable = 'on';
                app.HighPassReinforcementButton.Enable = 'on';
                app.RobertsButton.Enable = 'on';
                app.PrewittButton.Enable = 'on';
                app.MeanFilterButton.Enable = 'on';
                app.LoGButton.Enable = 'on';
                app.ZeroCrossButton.Enable = 'on';
                app.NoiseButton.Enable = 'on';
                app.WatershedButton.Enable = 'on';
                app.CountObjectsButton.Enable = 'on';
                app.HistogramButton.Enable = 'on';
                app.CLAHEHistogramButton.Enable = 'on';
            catch ME
                errordlg(['Erro ao carregar a imagem: ', ME.message], 'Erro');
            end
        end

        % Grayscale Button
        function GrayscaleButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            imshow(grayImage, 'Parent', app.FilteredImageAxes);
            msgbox('Imagem convertida para escala de cinza!', 'Sucesso');
        end

        % Threshold Button
        function ThresholdButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            prompt = {'Informe o valor do limiar (0 a 1):'};
            dlgtitle = 'Limiarização';
            dims = [1 35];
            definput = {'0.5'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            if isempty(answer)
                return;
            end
            thresholdValue = str2double(answer{1});
            if isnan(thresholdValue) || thresholdValue < 0 || thresholdValue > 1
                errordlg('Valor inválido! Informe um valor entre 0 e 1.', 'Erro');
                return;
            end
            grayImage = im2gray(app.Image);
            binaryImage = imbinarize(grayImage, thresholdValue);
            imshow(binaryImage, 'Parent', app.FilteredImageAxes);
            msgbox('Limiarização aplicada com sucesso!', 'Sucesso');
        end

        function HighPassBasicButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            % Solicita o valor de alpha para o filtro Laplaciano ao usuário
            prompt = {'Informe o valor de alpha para o filtro Laplaciano (0 a 1):'};
            dlgtitle = 'Filtro Passa-Alta Básico';
            dims = [1 35];
            definput = {'0.2'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            if isempty(answer)
                return;
            end
            alpha = str2double(answer{1});
            if isnan(alpha) || alpha < 0 || alpha > 1
                errordlg('Valor inválido! Informe um valor entre 0 e 1.', 'Erro');
                return;
            end
            grayImage = im2gray(app.Image);
            h = fspecial('laplacian', alpha);
            highPassImage = imfilter(grayImage, h);
            imshow(highPassImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Passa-Alta Básico aplicado com sucesso!', 'Sucesso');
        end


        function HighPassReinforcementButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            % Solicita o valor de alpha para o filtro Laplaciano ao usuário
            prompt = {'Informe o valor de alpha para o filtro Laplaciano (0 a 1):'};
            dlgtitle = 'Filtro Passa-Alta com Reforço';
            dims = [1 35];
            definput = {'0.2'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            if isempty(answer)
                return;
            end
            alpha = str2double(answer{1});
            if isnan(alpha) || alpha < 0 || alpha > 1
                errordlg('Valor inválido! Informe um valor entre 0 e 1.', 'Erro');
                return;
            end
            grayImage = im2gray(app.Image);
            h = fspecial('laplacian', alpha);
            highPassImage = imfilter(grayImage, h);
            reinforcementImage = imadd(grayImage, highPassImage);
            imshow(reinforcementImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Passa-Alta com Alto Reforço aplicado com sucesso!', 'Sucesso');
        end

        
        % Passa-Baixa Mediana Button
        function MedianFilterButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            prompt = {'Informe o tamanho da janela de filtragem (ímpar):'};
            dlgtitle = 'Filtro Mediana';
            dims = [1 35];
            definput = {'3'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            if isempty(answer)
                return;
            end
            windowSize = str2double(answer{1});
            if isnan(windowSize) || mod(windowSize, 2) == 0 || windowSize < 1
                errordlg('Valor inválido! Informe um valor ímpar maior que 0.', 'Erro');
                return;
            end
            grayImage = im2gray(app.Image);
            medianFilteredImage = medfilt2(grayImage, [windowSize windowSize]);
            imshow(medianFilteredImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro de Mediana aplicado com sucesso!', 'Sucesso');
        end

                % Passa-Baixa Média Button
              function MeanFilterButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            % Solicita o tamanho da janela de filtragem ao usuário
            prompt = {'Informe o tamanho da janela de filtragem (ímpar):'};
            dlgtitle = 'Filtro de Média';
            dims = [1 35];
            definput = {'3'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            if isempty(answer)
                return;
            end
            windowSize = str2double(answer{1});
            if isnan(windowSize) || mod(windowSize, 2) == 0 || windowSize < 1
                errordlg('Valor inválido! Informe um valor ímpar maior que 0.', 'Erro');
                return;
            end
            grayImage = im2gray(app.Image);
            meanFilteredImage = imfilter(grayImage, fspecial('average', [windowSize windowSize]));
            imshow(meanFilteredImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Passa-Baixa (Média) aplicado com sucesso!', 'Sucesso');
        end
        % Filtros de Detecção de Bordas (Roberts, Prewitt, Sobel, LoG, Zero-Cross, Canny)
        function RobertsButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            robertsImage = edge(grayImage, 'Roberts');
            imshow(robertsImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Roberts aplicado com sucesso!', 'Sucesso');
        end
        
        function PrewittButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            prewittImage = edge(grayImage, 'Prewitt');
            imshow(prewittImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Prewitt aplicado com sucesso!', 'Sucesso');
        end

        function SobelButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            sobelImage = edge(grayImage, 'Sobel');
            imshow(sobelImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Sobel aplicado com sucesso!', 'Sucesso');
        end

        function LoGButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            logImage = edge(grayImage, 'log');
            imshow(logImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Laplaciano do Gaussiano (LoG) aplicado com sucesso!', 'Sucesso');
        end

        function ZeroCrossButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            logImage = edge(grayImage, 'log');
            zeroCrossImage = edge(logImage, 'zerocross');
            imshow(zeroCrossImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Zero-Cross aplicado com sucesso!', 'Sucesso');
        end

        function CannyButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            prompt = {'Informe o valor mínimo do threshold:', 'Informe o valor máximo do threshold:'};
            dlgtitle = 'Filtro Canny';
            dims = [1 35];
            definput = {'0.1', '0.3'};
            answer = inputdlg(prompt, dlgtitle, dims, definput);
            if isempty(answer)
                return;
            end
            minThreshold = str2double(answer{1});
            maxThreshold = str2double(answer{2});
            if isnan(minThreshold) || isnan(maxThreshold) || minThreshold < 0 || maxThreshold > 1 || minThreshold >= maxThreshold
                errordlg('Valores inválidos! Informe valores entre 0 e 1, e que o valor mínimo seja menor que o máximo.', 'Erro');
                return;
            end
            grayImage = im2gray(app.Image);
            cannyImage = edge(grayImage, 'Canny', [minThreshold maxThreshold]);
            imshow(cannyImage, 'Parent', app.FilteredImageAxes);
            msgbox('Filtro Canny aplicado com sucesso!', 'Sucesso');
        end

        % Adicionar Ruído Button
        function NoiseButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            noisyImage = imnoise(grayImage, 'salt & pepper', 0.02);
            imshow(noisyImage, 'Parent', app.FilteredImageAxes);
            msgbox('Ruído salt & pepper adicionado à imagem!', 'Sucesso');
        end

        % Watershed Button
        function WatershedButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            D = -bwdist(~imbinarize(grayImage));
            mask = imextendedmin(D, 2);
            D2 = imimposemin(D, mask);
            Ld2 = watershed(D2);
            watershedImage = label2rgb(Ld2, 'jet', 'w', 'shuffle');
            imshow(watershedImage, 'Parent', app.FilteredImageAxes);
            msgbox('Transformação Watershed aplicada com sucesso!', 'Sucesso');
        end

        % Contagem de Objetos Redondos usando Transformada Hough Circular
        function CountObjectsButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            
            grayImage = im2gray(app.Image);
            
            [centers, radii] = imfindcircles(grayImage, [20 50], 'ObjectPolarity', 'dark', 'Sensitivity', 0.9);
            
            numCircles = length(centers);
            
            imshow(app.Image, 'Parent', app.FilteredImageAxes);
            hold(app.FilteredImageAxes, 'on');
            
            viscircles(app.FilteredImageAxes, centers, radii, 'EdgeColor', 'r');
            
            for k = 1:numCircles
                centerX = centers(k, 1);
                centerY = centers(k, 2);
                text(app.FilteredImageAxes, centerX, centerY, num2str(k), 'Color', 'yellow', 'FontSize', 12, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
            end
            
            hold(app.FilteredImageAxes, 'off');
            
            msgbox(sprintf('Contagem de objetos redondos: %d', numCircles), 'Resultado');
        end

                % Histogram Button
                function HistogramButtonPushed(app, event)
            if isempty(app.Image)
                return;
            end
            grayImage = im2gray(app.Image);
            
            % Exibe a imagem em escala de cinza no eixo de imagem filtrada
            imshow(grayImage, 'Parent', app.FilteredImageAxes);
            
            % Limpa o eixo de histograma antes de desenhar o novo histograma
            cla(app.HistogramAxes);
            
            % Calcula o histograma da imagem em escala de cinza
            [counts, binLocations] = imhist(grayImage);
            
            % Plota o histograma no eixo apropriado
            bar(app.HistogramAxes, binLocations, counts);
            title(app.HistogramAxes, 'Histograma da Imagem em Escala de Cinza');
            xlabel(app.HistogramAxes, 'Intensidade de Cinza');
            ylabel(app.HistogramAxes, 'Frequência');
        end
        function CLAHEHistogramButtonPushed(app, event)
    if isempty(app.Image)
        return;
    end
    grayImage = im2gray(app.Image);
    
            % Aplica CLAHE à imagem em escala de cinza
            adaptedImage = adapthisteq(grayImage);
            
            % Exibe a imagem adaptada no eixo de imagem filtrada
            imshow(adaptedImage, 'Parent', app.FilteredImageAxes);
            
            % Limpa o eixo de histograma antes de desenhar o novo histograma
            cla(app.HistogramAxes);
            
            % Calcula o histograma da imagem após CLAHE
            [counts, binLocations] = imhist(adaptedImage);
            bar(app.HistogramAxes, binLocations, counts);
            title(app.HistogramAxes, 'Histograma Após CLAHE');
            xlabel(app.HistogramAxes, 'Intensidade de Cinza');
            ylabel(app.HistogramAxes, 'Frequência');
        end
    end
    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1200 750]; 
            app.UIFigure.Name = 'MATLAB Image Processing App';

            % Create OriginalImageAxes
            app.OriginalImageAxes = uiaxes(app.UIFigure);
            title(app.OriginalImageAxes, 'Original Image');
            app.OriginalImageAxes.Position = [50 400 500 250]; 

            % Create FilteredImageAxes
            app.FilteredImageAxes = uiaxes(app.UIFigure);
            title(app.FilteredImageAxes, 'Filtered Image');
            app.FilteredImageAxes.Position = [650 400 500 250];

            % Create HistogramAxes
            app.HistogramAxes = uiaxes(app.UIFigure);
            title(app.HistogramAxes, 'Histograma');
            app.HistogramAxes.Position = [700 50 400 250];  % Ajusta a posição do histograma

            % Create buttons and set their positions
            buttonWidth = 110;
            buttonHeight = 30;
            xOffset = 50;
            yOffset = 330;
            buttonSpacing = 10;

            % Reorganiza os botões em colunas ao lado do histograma
            colOffset = 50;
            rowOffset = 350;

            app.LoadImageButton = uibutton(app.UIFigure, 'push', 'Text', 'Load Image', ...
                'Position', [colOffset, rowOffset, buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) LoadImageButtonPushed(app));

            app.ThresholdButton = uibutton(app.UIFigure, 'push', 'Text', 'Apply Threshold', ...
                'Position', [colOffset, rowOffset - (buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) ThresholdButtonPushed(app), 'Enable', 'off');

            app.GrayscaleButton = uibutton(app.UIFigure, 'push', 'Text', 'Grayscale', ...
                'Position', [colOffset, rowOffset - 2*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) GrayscaleButtonPushed(app), 'Enable', 'off');

            app.SobelButton = uibutton(app.UIFigure, 'push', 'Text', 'Sobel', ...
                'Position', [colOffset, rowOffset - 3*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) SobelButtonPushed(app), 'Enable', 'off');

            app.CannyButton = uibutton(app.UIFigure, 'push', 'Text', 'Canny', ...
                'Position', [colOffset, rowOffset - 4*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) CannyButtonPushed(app), 'Enable', 'off');

            app.MedianFilterButton = uibutton(app.UIFigure, 'push', 'Text', 'Median Filter', ...
                'Position', [colOffset, rowOffset - 5*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) MedianFilterButtonPushed(app), 'Enable', 'off');

            app.HistogramButton = uibutton(app.UIFigure, 'push', 'Text', 'Histogram', ...
                'Position', [colOffset, rowOffset - 6*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) HistogramButtonPushed(app), 'Enable', 'off');

            app.CLAHEHistogramButton = uibutton(app.UIFigure, 'push', 'Text', 'CLAHE Histogram', ...
                'Position', [colOffset, rowOffset - 7*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) CLAHEHistogramButtonPushed(app), 'Enable', 'off');

            % Segunda coluna de botões
            colOffset = colOffset + buttonWidth + buttonSpacing;

            app.HighPassBasicButton = uibutton(app.UIFigure, 'push', 'Text', 'High Pass - Basic', ...
                'Position', [colOffset, rowOffset, buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) HighPassBasicButtonPushed(app), 'Enable', 'off');

            app.HighPassReinforcementButton = uibutton(app.UIFigure, 'push', 'Text', 'High Pass - Reinforcement', ...
                'Position', [colOffset, rowOffset - (buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) HighPassReinforcementButtonPushed(app), 'Enable', 'off');

            app.RobertsButton = uibutton(app.UIFigure, 'push', 'Text', 'Roberts', ...
                'Position', [colOffset, rowOffset - 2*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) RobertsButtonPushed(app), 'Enable', 'off');

            app.PrewittButton = uibutton(app.UIFigure, 'push', 'Text', 'Prewitt', ...
                'Position', [colOffset, rowOffset - 3*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) PrewittButtonPushed(app), 'Enable', 'off');

            app.MeanFilterButton = uibutton(app.UIFigure, 'push', 'Text', 'Mean Filter', ...
                'Position', [colOffset, rowOffset - 4*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) MeanFilterButtonPushed(app), 'Enable', 'off');

            app.LoGButton = uibutton(app.UIFigure, 'push', 'Text', 'LoG', ...
                'Position', [colOffset, rowOffset - 5*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) LoGButtonPushed(app), 'Enable', 'off');

            app.ZeroCrossButton = uibutton(app.UIFigure, 'push', 'Text', 'Zero Cross', ...
                'Position', [colOffset, rowOffset - 6*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) ZeroCrossButtonPushed(app), 'Enable', 'off');

            app.NoiseButton = uibutton(app.UIFigure, 'push', 'Text', 'Add Noise', ...
                'Position', [colOffset, rowOffset - 7*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) NoiseButtonPushed(app), 'Enable', 'off');

            app.WatershedButton = uibutton(app.UIFigure, 'push', 'Text', 'Watershed', ...
                'Position', [colOffset, rowOffset - 8*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) WatershedButtonPushed(app), 'Enable', 'off');

            app.CountObjectsButton = uibutton(app.UIFigure, 'push', 'Text', 'Count Objects', ...
                'Position', [colOffset, rowOffset - 9*(buttonHeight + buttonSpacing), buttonWidth, buttonHeight], ...
                'ButtonPushedFcn', @(btn,event) CountObjectsButtonPushed(app), 'Enable', 'off');

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App initialization and construction
    methods (Access = public)

        % Construct app
        function app = ImageProcessingApp

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
