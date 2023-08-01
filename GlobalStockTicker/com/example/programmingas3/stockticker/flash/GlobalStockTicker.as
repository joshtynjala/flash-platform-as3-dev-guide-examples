package com.example.programmingas3.stockticker.flash
{
	import com.example.programmingas3.stockticker.FinancialGraph;
	import com.example.programmingas3.stockticker.Localizer;
	import com.example.programmingas3.stockticker.StockDataModel;
	import com.example.programmingas3.stockticker.flash.RightAlignedCell;
	
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.display.MovieClip;
	
	/** 
	 * This is the Flash Professional version of the UI and controller for the
	 * Global Stock Ticker example in the ActionScript 3.0 Developer's Guide.
	 * 
	 * If you are using Flash Builder or the Flex SDK you do not need this file. 
	 * The UI and control will be handled in the file GlobalStockTicker.mxml.
	 */
	public class GlobalStockTicker extends MovieClip
	{
		public var graph:FinancialGraph;
		public var localizer:Localizer;
		public var stockData:StockDataModel;
		
		public var currentLocale:String;
		public var marketIndex:int = 0;
		
		public function GlobalStockTicker()
		{
			init();
		}
		
		public function init():void
		{
			stockData = new StockDataModel();
			
			// select US market by default	
			currentLocale = "en-US";
			localizer = new Localizer();
			loadCurrentLocale();
			// specify USD for the initial currency
			localizer.setFormatProperties(2, "USD", "$");
			
			setUpCombos();
			setUpGrid();

// set the company data provider to the list of US companies
			companyGrid.dataProvider = new DataProvider(stockData.stocks[marketIndex]);
			
			setUpGraph();
		}
		public function loadCurrentLocale():void
		{
			localizer.setLocale(currentLocale);
			currentTimeTxt.text = localizer.formatDate(new Date());	
			month1Txt.text = localizer.monthNames[3];
			month2Txt.text = localizer.monthNames[4];
			month3Txt.text = localizer.monthNames[5];
			month4Txt.text = localizer.monthNames[6];
			month5Txt.text = localizer.monthNames[7];
			month6Txt.text = localizer.monthNames[8];
		}
		
		private function setUpCombos():void
		{
			this.localeCbo.dataProvider = new DataProvider(stockData.locales);
			this.localeCbo.addEventListener(ListEvent.ITEM_CLICK, onLocaleSelected);
			
			this.marketCbo.dataProvider = new DataProvider(stockData.markets);
			this.marketCbo.addEventListener(ListEvent.ITEM_CLICK, onMarketSelected);
		}
		
		private function setUpGrid():void
		{
			var col1:DataGridColumn = new DataGridColumn("ticker");
			col1.headerText = "Company";
			col1.sortOptions = Array.NUMERIC;
			col1.width = 200;
			
			var col2:DataGridColumn = new DataGridColumn("volume");
			col2.headerText = "Volume";
			col2.width = 120;
			col2.cellRenderer = RightAlignedCell;
			col2.labelFunction = displayVolume;
			
			var col3:DataGridColumn = new DataGridColumn("price");
			col3.headerText = "Price";
			col3.width = 70;
			col3.cellRenderer = RightAlignedCell;
			col3.labelFunction = displayPrice;
			
			var col4:DataGridColumn = new DataGridColumn("change");
			col4.headerText = "Change";
			col4.width = 120;
			col4.cellRenderer = RightAlignedCell;
			col4.labelFunction = displayPercent;
			
			this.companyGrid.addColumn(col1);
			this.companyGrid.addColumn(col2);
			this.companyGrid.addColumn(col3);
			this.companyGrid.addColumn(col4);
			
			this.companyGrid.addEventListener(ListEvent.ITEM_CLICK, onCompanySelected);
		}
		
		private function setUpGraph(w:int = 740, h:int = 285):void
		{
			graph = new FinancialGraph(w, h, 0x80ffff);
			graph.x = 20;
			graph.y = 280;
			graph.init();
			
			this.addChild(graph);
		}
        private function onLocaleSelected(event:ListEvent):void 
		{
			var rowIndex:int = event.rowIndex as int;
			currentLocale = event.target.dataProvider.getItemAt(rowIndex).data;
        	loadCurrentLocale();
			
			// refresh the datagrid
			companyGrid.dataProvider = new DataProvider(stockData.stocks[marketIndex]);
        } 
		
        private function onMarketSelected(event:ListEvent):void 
		{
			var rowIndex:int = event.rowIndex as int;
			var dataItem:Object = event.target.dataProvider.getItemAt(rowIndex);
			localizer.setFormatProperties(dataItem.fraction, dataItem.currency, dataItem.symbol);
			loadCurrentLocale();
			if (rowIndex >= 0 && rowIndex < stockData.stocks.length)
			{
				marketIndex = rowIndex;
        		companyGrid.dataProvider = new DataProvider(stockData.stocks[marketIndex]);
        	}
        }
		
        private function onCompanySelected(event:ListEvent):void 
		{
			graph.redraw();
		}
		
		private function displayVolume(item:Object):String
		 {
		   	return localizer.formatNumber(item.volume, 0);
		 }
		
		private function displayPercent(item:Object):String
		 {
		   	return localizer.formatPercent(item.change);
		 }
		 
		private function displayPrice(item:Object):String
		 {
		   	return localizer.formatCurrency(item.price);
		 }
	}
}